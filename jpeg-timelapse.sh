#!/usr/bin/env bash
# Build a timelapse MOV from landscape JPEGs in a directory.
# Usage: jpeg-timelapse.sh [OPTIONS] DIRECTORY
#   DIRECTORY   e.g. Pictures/todo/2026/plex or /full/path/to/folder
#   -f, --fps N     Frames per second (2–5, default 3)
#   -l, --limit N   Use only first N images (for testing)
#   -o, --out FILE  Output path (default: timelapse_<dirname>_<date>.mov)
set -euo pipefail

FPS=8
LIMIT=""
OUTPUT=""
DIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--fps)
            FPS="$2"
            shift 2
            ;;
        -l|--limit)
            LIMIT="$2"
            shift 2
            ;;
        -o|--out)
            OUTPUT="$2"
            shift 2
            ;;
        -*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            DIR="$1"
            shift
            ;;
    esac
done

if [[ -z "$DIR" ]]; then
    echo "Usage: $0 [ -f FPS ] [ -l LIMIT ] [ -o OUTPUT ] DIRECTORY"
    echo "  -f, --fps N    Frames per second (default 8, try 3–15)"
    echo "  -l, --limit N  Use only first N images (e.g. 20 to test)"
    echo "  -o, --out FILE Output path (default: timelapse_<dirname>_<date>.mov)"
    exit 1
fi

# Resolve directory (allow Pictures/todo/2026/plex from $HOME)
if [[ ! "$DIR" = /* ]]; then
    DIR="$HOME/$DIR"
fi

if [[ ! -d "$DIR" ]]; then
    echo "Directory not found: $DIR" >&2
    exit 1
fi

# Validate FPS (allow 1–10 for flexibility)
if [[ ! "$FPS" =~ ^[0-9]+\.?[0-9]*$ ]]; then
    echo "FPS must be a number (e.g. 2, 3, 5)." >&2
    exit 1
fi

# Collect landscape JPEGs (width > height) using sips on macOS
# Use a temp file to avoid process-substitution / read -d '' issues on macOS bash 3.2
TMPLIST=$(mktemp)
CONCAT=$(mktemp)
trap 'rm -f "$TMPLIST" "$CONCAT"' EXIT

for f in "$DIR"/*.jpg "$DIR"/*.jpeg "$DIR"/*.JPG "$DIR"/*.JPEG; do
    [[ -f "$f" ]] || continue
    info=$(sips -g pixelWidth -g pixelHeight -g orientation "$f" 2>/dev/null)
    w=$(echo "$info" | awk '/pixelWidth:/{print $2}')
    h=$(echo "$info" | awk '/pixelHeight:/{print $2}')
    o=$(echo "$info" | awk '/orientation:/{print $2}')
    [[ -n "$w" && -n "$h" ]] || continue
    # orientations 5–8 mean the image is rotated 90/270°, so displayed dimensions are swapped
    if [[ "$o" =~ ^[0-9]+$ && "$o" -ge 5 ]]; then
        tmp=$w; w=$h; h=$tmp
    fi
    if [[ "$w" -gt "$h" ]]; then
        echo "$f"
    fi
done | sort -u > "$TMPLIST"

LANDSCAPE=()
while IFS= read -r f; do
    [[ -n "$f" ]] && LANDSCAPE+=("$f")
done < "$TMPLIST"

# Limit if requested
if [[ -n "$LIMIT" ]]; then
    LANDSCAPE=("${LANDSCAPE[@]:0:$LIMIT}")
fi

COUNT=${#LANDSCAPE[@]}
if [[ "$COUNT" -eq 0 ]]; then
    echo "No landscape JPEGs found in: $DIR" >&2
    exit 1
fi

echo "Using $COUNT landscape image(s) at ${FPS} fps"
for i in "${!LANDSCAPE[@]}"; do
    echo "  [$((i + 1))] $(basename "${LANDSCAPE[$i]}")"
done

# Default output path
if [[ -z "$OUTPUT" ]]; then
    BASENAME=$(basename "$DIR")
    OUTPUT="$HOME/Pictures/timelapse_${BASENAME}_$(date +%Y%m%d_%H%M%S).mov"
fi

# Concat list: one "file 'path'" per image in order (files stay in place, no copy/rename)
for i in "${!LANDSCAPE[@]}"; do
    printf '%s\n' "${LANDSCAPE[$i]}" | awk "{ gsub(/'/, \"'\\''\"); print \"file '\" \$0 \"'\" }"
done >> "$CONCAT"

# -r before -i = INPUT rate: each image lasts 1/FPS seconds (not the mjpeg default of 25fps)
# scale to 1080p height (keeps aspect ratio, divisible by 2 for yuv420p)
ffmpeg -y -noautorotate -r "$FPS" -f concat -safe 0 -i "$CONCAT" \
    -vf "scale=-2:1080" \
    -c:v libx264 -pix_fmt yuv420p -movflags +faststart \
    "$OUTPUT"

echo "Wrote: $OUTPUT"
