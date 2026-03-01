# JPEG Timelapse
Generate a timelapse mov from a directory of JPEG images

The script relies on [ffmpeg](https://www.ffmpeg.org/)

```bash
 bash jpeg-timelapse.sh -l 20 ~/Pictures/example/
Using 20 landscape image(s) at 5 fps
  [1] DSCF1115.JPG
  [2] DSCF1116.JPG
  [3] DSCF1117.JPG
  [4] DSCF1118.JPG
  [5] DSCF1119.JPG
  [6] DSCF1120.JPG
  [7] DSCF1121.JPG
  [8] DSCF1122.JPG
  [9] DSCF1123.JPG
  [10] DSCF1124.JPG
  [11] DSCF1125.JPG
  [12] DSCF1126.JPG
  [13] DSCF1127.JPG
  [14] DSCF1128.JPG
  [15] DSCF1129.JPG
  [16] DSCF1130.JPG
  [17] DSCF1131.JPG
  [18] DSCF1132.JPG
  [19] DSCF1133.JPG
  [20] DSCF1134.JPG
ffmpeg version 7.1.1 Copyright (c) 2000-2025 the FFmpeg developers
  built with Apple clang version 15.0.0 (clang-1500.1.0.2.5)
  configuration: --prefix=/opt/homebrew/Cellar/ffmpeg/7.1.1_3 --enable-shared --enable-pthreads --enable-version3 --cc=clang --host-cflags= --host-ldflags='-Wl,-ld_classic' --enable-ffplay --enable-gnutls --enable-gpl --enable-libaom --enable-libaribb24 --enable-libbluray --enable-libdav1d --enable-libharfbuzz --enable-libjxl --enable-libmp3lame --enable-libopus --enable-librav1e --enable-librist --enable-librubberband --enable-libsnappy --enable-libsrt --enable-libssh --enable-libsvtav1 --enable-libtesseract --enable-libtheora --enable-libvidstab --enable-libvmaf --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxml2 --enable-libxvid --enable-lzma --enable-libfontconfig --enable-libfreetype --enable-frei0r --enable-libass --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-libspeex --enable-libsoxr --enable-libzmq --enable-libzimg --disable-libjack --disable-indev=jack --enable-videotoolbox --enable-audiotoolbox --enable-neon
  libavutil      59. 39.100 / 59. 39.100
  libavcodec     61. 19.101 / 61. 19.101
  libavformat    61.  7.100 / 61.  7.100
  libavdevice    61.  3.100 / 61.  3.100
  libavfilter    10.  4.100 / 10.  4.100
  libswscale      8.  3.100 /  8.  3.100
  libswresample   5.  3.100 /  5.  3.100
  libpostproc    58.  3.100 / 58.  3.100
Input #0, concat, from '/var/folders/zn/tsphy4ld75x3sj82v4qpxqzh0000gn/T/tmp.cAFf9JbD':
  Duration: N/A, start: 0.000000, bitrate: N/A
  Stream #0:0: Video: mjpeg (Baseline), yuvj422p(pc, bt470bg/unknown/unknown), 6240x4160, 25 fps, 25 tbr, 25 tbn
Stream mapping:
  Stream #0:0 -> #0:0 (mjpeg (native) -> h264 (libx264))
Press [q] to stop, [?] for help
[swscaler @ 0x120058000] deprecated pixel format used, make sure you did set range correctly
[libx264 @ 0x130804cd0] using cpu capabilities: ARMv8 NEON
[libx264 @ 0x130804cd0] profile High, level 4.0, 4:2:0, 8-bit
[libx264 @ 0x130804cd0] 264 - core 164 r3108 31e19f9 - H.264/MPEG-4 AVC codec - Copyleft 2003-2023 - http://www.videolan.org/x264.html - options: cabac=1 ref=3 deblock=1:0:0 analyse=0x3:0x113 me=hex subme=7 psy=1 psy_rd=1.00:0.00 mixed_ref=1 me_range=16 chroma_me=1 trellis=1 8x8dct=1 cqm=0 deadzone=21,11 fast_pskip=1 chroma_qp_offset=-2 threads=15 lookahead_threads=2 sliced_threads=0 nr=0 decimate=1 interlaced=0 bluray_compat=0 constrained_intra=0 bframes=3 b_pyramid=2 b_adapt=1 b_bias=0 direct=1 weightb=1 open_gop=0 weightp=2 keyint=250 keyint_min=5 scenecut=40 intra_refresh=0 rc_lookahead=40 rc=crf mbtree=1 crf=23.0 qcomp=0.60 qpmin=0 qpmax=69 qpstep=4 ip_ratio=1.40 aq=1:1.00
Output #0, mov, to '~/Pictures/example/timelapse_example_20260223_154900.mov':
  Metadata:
    encoder         : Lavf61.7.100
  Stream #0:0: Video: h264 (avc1 / 0x31637661), yuv420p(pc, bt470bg/unknown/unknown, progressive), 1620x1080, q=2-31, 5 fps, 10240 tbn
      Metadata:
        encoder         : Lavc61.19.101 libx264
      Side data:
        cpb: bitrate max/min/avg: 0/0/0 buffer size: 0 vbv_delay: N/A
[mov @ 0x1308041f0] Starting second pass: moving the moov atom to the beginning of the file
[out#0/mov @ 0x60000277c000] video:1184KiB audio:0KiB subtitle:0KiB other streams:0KiB global headers:0KiB muxing overhead: 0.075529%
frame=   20 fps=5.1 q=-1.0 Lsize=    1185KiB time=00:00:03.60 bitrate=2697.1kbits/s speed=0.915x
[libx264 @ 0x130804cd0] frame I:1     Avg QP:17.18  size: 38622
[libx264 @ 0x130804cd0] frame P:19    Avg QP:17.31  size: 61762
[libx264 @ 0x130804cd0] mb I  I16..4: 23.2% 51.7% 25.1%
[libx264 @ 0x130804cd0] mb P  I16..4: 15.4% 50.1% 20.7%  P16..4:  9.7%  1.9%  0.8%  0.0%  0.0%    skip: 1.3%
[libx264 @ 0x130804cd0] 8x8 transform intra:57.7% inter:82.0%
[libx264 @ 0x130804cd0] coded y,uvDC,uvAC intra: 52.2% 59.6% 32.2% inter: 43.3% 66.4% 7.0%
[libx264 @ 0x130804cd0] i16 v,h,dc,p: 37% 21%  9% 33%
[libx264 @ 0x130804cd0] i8 v,h,dc,ddl,ddr,vr,hd,vl,hu: 23% 18% 26%  5%  6%  5%  6%  4%  5%
[libx264 @ 0x130804cd0] i4 v,h,dc,ddl,ddr,vr,hd,vl,hu: 35% 21% 25%  4%  5%  3%  4%  2%  2%
[libx264 @ 0x130804cd0] i8c dc,h,v,p: 52% 21% 19%  7%
[libx264 @ 0x130804cd0] Weighted P-Frames: Y:0.0% UV:0.0%
[libx264 @ 0x130804cd0] ref P L0: 60.7%  6.8% 21.1% 11.4%
[libx264 @ 0x130804cd0] kb/s:2424.19
Wrote: ~/Pictures/example/timelapse_example_20260223_154900.mov
```
