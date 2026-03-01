<#
.SYNOPSIS
    Build a timelapse MOV from landscape JPEGs in a directory.
.DESCRIPTION
    Scans a directory for JPEG images, filters to landscape orientation
    (accounting for EXIF rotation), and encodes a timelapse video using ffmpeg.
.EXAMPLE
    .\jpeg-timelapse.ps1 -Limit 20 C:\Users\me\Pictures\photos
.EXAMPLE
    .\jpeg-timelapse.ps1 -Fps 10 -Limit 50 .\photos
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Directory,

    [Alias("f")]
    [double]$Fps = 8,

    [Alias("l")]
    [int]$Limit = 0,

    [Alias("o")]
    [string]$Out = ""
)

$ErrorActionPreference = "Stop"

# Resolve directory
if (-not [System.IO.Path]::IsPathRooted($Directory)) {
    $Directory = Join-Path $PWD $Directory
}
if (-not (Test-Path -LiteralPath $Directory -PathType Container)) {
    Write-Error "Directory not found: $Directory"
    exit 1
}
$Directory = (Resolve-Path -LiteralPath $Directory).Path

# Validate FPS
if ($Fps -le 0) {
    Write-Error "FPS must be a positive number (e.g. 3, 5, 8)."
    exit 1
}

# Check ffprobe is available
if (-not (Get-Command ffprobe -ErrorAction SilentlyContinue)) {
    Write-Error "ffprobe not found. Install ffmpeg (includes ffprobe): https://www.ffmpeg.org/download.html"
    exit 1
}
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Write-Error "ffmpeg not found. Install from: https://www.ffmpeg.org/download.html"
    exit 1
}

# Collect JPEGs (deduplicate for case-insensitive FS)
$allJpegs = Get-ChildItem -LiteralPath $Directory -File -Include *.jpg, *.jpeg |
    Sort-Object -Property FullName -Unique

if ($allJpegs.Count -eq 0) {
    Write-Error "No JPEGs found in: $Directory"
    exit 1
}

# Filter to landscape images using ffprobe for dimensions and rotation
$landscape = @()
foreach ($file in $allJpegs) {
    $json = & ffprobe -v quiet -print_format json -show_streams $file.FullName 2>$null
    if (-not $json) { continue }

    $streams = ($json | ConvertFrom-Json).streams
    $videoStream = $streams | Where-Object { $_.codec_type -eq "video" } | Select-Object -First 1
    if (-not $videoStream) { continue }

    [int]$w = $videoStream.width
    [int]$h = $videoStream.height

    # Check for rotation in side_data or tags
    $rotation = 0
    if ($videoStream.side_data_list) {
        foreach ($sd in $videoStream.side_data_list) {
            if ($sd.rotation) {
                $rotation = [Math]::Abs([int]$sd.rotation)
            }
        }
    }
    if ($rotation -eq 0 -and $videoStream.tags -and $videoStream.tags.rotate) {
        $rotation = [Math]::Abs([int]$videoStream.tags.rotate)
    }

    # 90/270 degree rotation swaps effective dimensions
    if ($rotation -eq 90 -or $rotation -eq 270) {
        $tmp = $w; $w = $h; $h = $tmp
    }

    if ($w -gt $h) {
        $landscape += $file
    }
}

# Apply limit
if ($Limit -gt 0 -and $landscape.Count -gt $Limit) {
    $landscape = $landscape[0..($Limit - 1)]
}

$count = $landscape.Count
if ($count -eq 0) {
    Write-Error "No landscape JPEGs found in: $Directory"
    exit 1
}

Write-Host "Using $count landscape image(s) at $Fps fps"
for ($i = 0; $i -lt $count; $i++) {
    Write-Host "  [$($i + 1)] $($landscape[$i].Name)"
}

# Default output path
if (-not $Out) {
    $dirName = Split-Path -Leaf $Directory
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $Out = Join-Path $env:USERPROFILE "Pictures\timelapse_${dirName}_${timestamp}.mov"
}

# Build concat file
$concatFile = [System.IO.Path]::GetTempFileName()
try {
    $lines = foreach ($file in $landscape) {
        $escaped = $file.FullName -replace "'", "'\''"
        "file '$escaped'"
    }
    $lines | Set-Content -LiteralPath $concatFile -Encoding UTF8

    Write-Host ""
    Write-Host "Encoding to: $Out"
    Write-Host ""

    & ffmpeg -y -noautorotate -r $Fps -f concat -safe 0 -i $concatFile `
        -vf "scale=-2:1080" `
        -c:v libx264 -pix_fmt yuv420p -movflags +faststart `
        $Out

    if ($LASTEXITCODE -ne 0) {
        Write-Error "ffmpeg failed with exit code $LASTEXITCODE"
        exit 1
    }

    Write-Host ""
    Write-Host "Wrote: $Out"
}
finally {
    Remove-Item -LiteralPath $concatFile -ErrorAction SilentlyContinue
}
