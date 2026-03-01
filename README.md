# JPEG Timelapse

Generate a fast timelapse video from a directory of landscape JPEG images using ffmpeg.

Filters to landscape-only images (accounting for EXIF rotation), scales to 1080p, and outputs an H.264 MOV.

## Installing ffmpeg

Both scripts require **ffmpeg**. The Windows script also uses **ffprobe** (bundled with ffmpeg).

### macOS

```bash
brew install ffmpeg
```

If you don't have Homebrew: https://brew.sh

### Windows

Pick one of:

```powershell
# winget (built into Windows 10/11)
winget install ffmpeg

# Chocolatey
choco install ffmpeg

# Scoop
scoop install ffmpeg
```

After installing, verify it's on your PATH:

```
ffmpeg -version
```

## Usage

### macOS / Linux (Bash)

```bash
bash jpeg-timelapse.sh [OPTIONS] DIRECTORY
```

### Windows (PowerShell)

```powershell
.\jpeg-timelapse.ps1 [OPTIONS] -Directory DIRECTORY
```

## Options

| Bash | PowerShell | Description | Default |
|------|------------|-------------|---------|
| `-f, --fps N` | `-Fps N` | Frames per second | 8 |
| `-l, --limit N` | `-Limit N` | Use only first N images (for testing) | all |
| `-o, --out FILE` | `-Out FILE` | Output file path | `~/Pictures/timelapse_<dir>_<timestamp>.mov` |

## Examples

Test with first 20 images at default 8 fps:

```bash
# macOS
bash jpeg-timelapse.sh -l 20 ~/Pictures/my-photos

# Windows
.\jpeg-timelapse.ps1 -Limit 20 C:\Users\me\Pictures\my-photos
```

Full run at 12 fps for a faster timelapse:

```bash
# macOS
bash jpeg-timelapse.sh -f 12 ~/Pictures/my-photos

# Windows
.\jpeg-timelapse.ps1 -Fps 12 C:\Users\me\Pictures\my-photos
```

Custom output path:

```bash
# macOS
bash jpeg-timelapse.sh -f 5 -o ~/Desktop/test.mov ~/Pictures/my-photos

# Windows
.\jpeg-timelapse.ps1 -Fps 5 -Out C:\Users\me\Desktop\test.mov C:\Users\me\Pictures\my-photos
```

## Output

```
Using 20 landscape image(s) at 8 fps
  [1] IMG_0001.JPG
  [2] IMG_0002.JPG
  ...
  [20] IMG_0020.JPG

Encoding to: ~/Pictures/timelapse_my-photos_20260223_160000.mov
...
Wrote: ~/Pictures/timelapse_my-photos_20260223_160000.mov
```

## How it works

1. Scans the directory for `.jpg` / `.jpeg` files (case-insensitive, deduplicated)
2. Checks each image's dimensions and EXIF orientation -- keeps only landscape images
3. Builds an ffmpeg concat list pointing at the original files (no copying)
4. Encodes with ffmpeg: H.264, 1080p scaled, yuv420p, faststart for streaming
