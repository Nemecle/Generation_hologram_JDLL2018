#!/bin/bash

echo "la capture durera 3 secondes !"
echo "Entrez votre mail afin que l'on vous envoie le fichier à postériori:"

read mail_addr

echo "(Attention, si vous vous trompez vous devrez refaire la vidéo !)"

captime=$(date +"%Y_%m%d_%H-%M-%S")

echo "$mail_addr: $captime" >> ~/liste_mail.txt

echo "capture dans..."
echo "5..."
sleep 1
echo "4..."
sleep 1
echo "3..."
sleep 1
echo "2..."
sleep 1
echo "1..."
sleep 1
echo "capture !"

streamer -q -c /dev/video0 -f rgb24 -r 25 -t 00:00:03 -o /home/jdll/holo_files/outfile.avi

echo "#######################"
echo "fini !"
echo "#######################"

echo "début du traitement : cela peut prendre jusqu'à une minute"

convert /home/jdll/holo_files/outfile.avi -background Black -scale 50% -rotate -45 -extent 200x200 -delay 4 /home/jdll/holo_files/out0.gif
convert /home/jdll/holo_files/outfile.avi -background Black -scale 50% -rotate 45 -extent 200x200 -delay 4 /home/jdll/holo_files/out1.gif
convert /home/jdll/holo_files/outfile.avi -background Black -scale 50% -rotate 135 -extent 200x200 -delay 4 /home/jdll/holo_files/out2.gif
convert /home/jdll/holo_files/outfile.avi -background Black -scale 50% -rotate 225 -extent 200x200 -delay 4 /home/jdll/holo_files/out3.gif

convert /home/jdll/holo_files/out0.gif -repage 400x200 -coalesce null: \( /home/jdll/holo_files/out1.gif -coalesce \) -geometry +200+0 -layers Composite /home/jdll/holo_files/out01.gif

convert /home/jdll/holo_files/out3.gif -repage 400x200 -coalesce null: \( /home/jdll/holo_files/out2.gif -coalesce \) -geometry +200+0 -layers Composite /home/jdll/holo_files/out32.gif

convert /home/jdll/holo_files/out01.gif -repage 400x400 -coalesce null: \( /home/jdll/holo_files/out32.gif -coalesce \) -geometry +0+200 -layers Composite /home/jdll/holo_files/videos/final_$captime.mp4


killall vlc

timeout 9 vlc --repeat /home/jdll/holo_files/videos/final_$captime.mp4
