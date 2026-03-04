cd "$PSScriptRoot"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
# 1. Surandame audio failus ir EQ foną
$audioFiles = Get-ChildItem -Path . | Where-Object { $_.Extension -in ".mp3", ".flac" }
$eqbg = Get-ChildItem -Path . -Filter "EQ.bmp" | Select-Object -First 1

foreach ($audio in $audioFiles) {
    Write-Host "`n[ PROCESAS ] Apdorojama: $($audio.Name)" -ForegroundColor Cyan

    # Ištraukiame viršelį į laikiną failą
    ffmpeg -v quiet -i "$($audio.FullName)" -an -vcodec copy -y "temp_cover.jpg"
    
    if (!(Test-Path "temp_cover.jpg")) {
        Write-Host "--- Klaida: Nerastas viršelis faile $($audio.Name). Praleidžiu." -ForegroundColor Red
        continue
    }

    # 2. Metadata ištraukimas (IŠTAISYTA: neberodys TAG:DATE)
    $metadata = ffprobe -v quiet -show_entries format_tags -of default=noprint_wrappers=1 "$($audio.FullName)"

    function Get-CleanTag($name, $meta) {
        $line = $meta | Select-String "^TAG:$name="
        if ($line) { 
            # Paimame tik tekstą po '=' ženklo
            $val = $line.ToString().Split('=', 2)[1]
            # Išvalome simbolius, kurie laužo FFmpeg
            return $val -replace "'", "" -replace ":", " " -replace "\[", "" -replace "\]", ""
        }
        return "Unknown"
    }

    $title   = Get-CleanTag "title" $metadata
    $artist  = Get-CleanTag "artist" $metadata
    $album   = Get-CleanTag "album" $metadata
    $year    = Get-CleanTag "date" $metadata
    if ($year -eq "Unknown") { $year = Get-CleanTag "year" $metadata }
    $comment = Get-CleanTag "comment" $metadata
    if ($title -eq "Unknown") { $title = $audio.BaseName }

    $out = "$($audio.BaseName).mkv"

    # 3. PAGRINDINĖ KOMANDA (tavo originalūs filtrai)
    # ČIA ĮKLIJUOK SAVO PILNĄ FILTER_COMPLEX (nuo [a1] iki drawtext)
    ffmpeg -loop 1 -i "temp_cover.jpg" -i "$($audio.FullName)" -loop 1 -i "$($eqbg.FullName)" `
    -filter_complex "[1:a]aformat=channel_layouts=mono,asplit=31[a1][a2][a3][a4][a5][a6][a7][a8][a9][a10][a11][a12][a13][a14][a15][a16][a17][a18][a19][a20][a21][a22][a23][a24][a25][a26][a27][a28][a29][a30][a31];
    [a1]bandpass=f=20:w=20,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v1];
    [a2]bandpass=f=25:w=25,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v2];
    [a3]bandpass=f=31.5:w=31.5,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v3];
    [a4]bandpass=f=40:w=40,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v4];
    [a5]bandpass=f=50:w=50,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v5];
    [a6]bandpass=f=63:w=63,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v6];
    [a7]bandpass=f=80:w=80,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v7];
    [a8]bandpass=f=100:w=100,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v8];
    [a9]bandpass=f=125:w=125,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v9];
    [a10]bandpass=f=160:w=160,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v10];
    [a11]bandpass=f=200:w=200,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v11];
    [a12]bandpass=f=250:w=250,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v12];
    [a13]bandpass=f=315:w=315,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v13];
    [a14]bandpass=f=400:w=400,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v14];
    [a15]bandpass=f=500:w=500,volume=5,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v15];
    [a16]bandpass=f=630:w=630,volume=6,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v16];
    [a17]bandpass=f=800:w=800,volume=7,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v17];
    [a18]bandpass=f=1000:w=1000,volume=8,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v18];
    [a19]bandpass=f=1250:w=1250,volume=9,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v19];
    [a20]bandpass=f=1600:w=1600,volume=10,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v20];
    [a21]bandpass=f=2000:w=2000,volume=11,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v21];
    [a22]bandpass=f=2500:w=2500,volume=12,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v22];
    [a23]bandpass=f=3150:w=3150,volume=13,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v23];
    [a24]bandpass=f=4000:w=4000,volume=14,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v24];
    [a25]bandpass=f=5000:w=5000,volume=15,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v25];
    [a26]bandpass=f=6300:w=6300,volume=16,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v26];
    [a27]bandpass=f=8000:w=8000,volume=17,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v27];
    [a28]bandpass=f=10000:w=10000,volume=18,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v28];
    [a29]bandpass=f=12500:w=12500,volume=19,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v29];
    [a30]bandpass=f=16000:w=16000,volume=20,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v30];
    [a31]bandpass=f=20000:w=20000,volume=21,compand=attacks=0.01:decays=0.2:points=-70/-70|-20/-15|-5/-5|0/-3:soft-knee=6,volume=0.8,showwaves=s=60x720:mode=cline:colors=0x00FF00[v31];
    [v1][v2][v3][v4][v5][v6][v7][v8][v9][v10][v11][v12][v13][v14][v15][v16][v17][v18][v19][v20][v21][v22][v23][v24][v25][v26][v27][v28][v29][v30][v31]hstack=inputs=31,dilation=1[eq_full];
    [2:v]scale=1920:1080[main_bg];
    [0:v]scale=610:610[resized_cover];
    [0:v]scale=194:194,format=rgba,geq=lum='p(X,Y)':a='if(gt(sqrt(pow(X-97,2)+pow(Y-97,2)),97),0,if(lt(sqrt(pow(X-97,2)+pow(Y-97,2)),10),0,255))',rotate=-45*PI/180:c=none:ow=iw:oh=ih,crop=114:194:0:0[vinyl_sticker];
    [main_bg][vinyl_sticker]overlay=1186:246[bg_with_sticker];
    [bg_with_sticker][resized_cover]overlay=1304:40[bg_with_all_covers];
    [bg_with_all_covers][eq_full]overlay=30:540,
    drawtext=fontfile='C\:/Windows/Fonts/arial.ttf':text='$title':x=186:y=43:fontsize=50:fontcolor=0xC58655:borderw=2:bordercolor=black,
    drawtext=fontfile='C\:/Windows/Fonts/arial.ttf':text='$artist':x=218:y=121:fontsize=50:fontcolor=0xC58655:borderw=2:bordercolor=black,
    drawtext=fontfile='C\:/Windows/Fonts/arial.ttf':text='$album':x=253:y=667:fontsize=50:fontcolor=0xC58655:borderw=2:bordercolor=black,
    drawtext=fontfile='C\:/Windows/Fonts/arial.ttf':text='$year':x=189:y=198:fontsize=50:fontcolor=0xC58655:borderw=2:bordercolor=black,
    drawtext=fontfile='C\:/Windows/Fonts/arial.ttf':text='$comment':x=349:y=591:fontsize=50:fontcolor=0xC58655:borderw=2:bordercolor=black[final]" `
    -map "[final]" -map 1:a -c:v libx264 -crf 18 -preset fast -pix_fmt yuv420p -r 30 -c:a copy -shortest "$out"

    # Ištriname laikiną viršelį
    Remove-Item "temp_cover.jpg" -ErrorAction SilentlyContinue
}