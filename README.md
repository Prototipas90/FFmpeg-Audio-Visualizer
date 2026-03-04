# FFmpeg-Audio-Visualizer
Automated PowerShell script to convert MP3/FLAC to video with a precise 31-band FFmpeg equalizer and embedded cover art extraction.
# 🎵 FFmpeg 31-Band Audio Visualizer (PowerShell)

Automated script to convert audio files into high-quality videos with a dynamic 31-band equalizer and embedded cover art extraction.

## 🚀 Features
- **31-Band Equalizer:** Uses precise `bandpass` filters for a professional visual effect.
- **Auto Cover Extraction:** Automatically pulls the album art from your MP3 or FLAC files.
- **Dynamic Metadata:** Displays Title, Artist, Album, Year, and Comments directly on the video.
- **Multilingual Support:** Supports Cyrillic (RU) and Baltic (LT) characters using Arial font.
- **Batch Processing:** Processes all audio files in the folder with one click.

## 🛠️ Requirements
- **FFmpeg:** Must be installed and added to your System PATH.
- **Windows PowerShell:** Standard on Windows 10/11.

## 📦 How to Use
1. Download `AudioVisualizer.ps1` and `EQ.bmp`.
2. Place both files into a folder containing your `.mp3` or `.flac` files.
3. Right-click `AudioVisualizer.ps1` -> **Run with PowerShell**.
4. Your videos will be generated as `[Filename]_PRO.mkv`.

## ⚠️ Credits & Legal
- **Background Image:** The `EQ.bmp` file contains graphic elements (Vinyl/CD visual) inspired by "WHY? – Album CD" designs found online. 
- **Usage:** This project is intended for personal and educational use. If you plan to use it commercially, please replace `EQ.bmp` with your own licensed artwork.
- **License:** MIT License - feel free to use and modify!

---
*Created with FFmpeg and PowerShell.*
