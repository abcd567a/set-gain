## Read and Set Gain from maps of dump1090-fa / dump1090-mutability
### (A) From below choose the bash script which is applicable your install, copy-paste it in the SSH window, and press Enter key. </br>

**For Piaware SD card image** </br>
`sudo bash -c "$(wget -O - https://raw.githubusercontent.com/abcd567a/set-gain/master/piaware-img.sh)" `
</br></br>
**For Raspbian image with dump1090-fa**</br>
`sudo bash -c "$(wget -O - https://raw.githubusercontent.com/abcd567a/set-gain/master/raspbian+dump-fa.sh)" `
</br></br>
**For Raspbian image with dump1090-mutability**</br>
`sudo bash -c "$(wget -O - https://raw.githubusercontent.com/abcd567a/set-gain/master/raspbian+dump-mut.sh)" `
</br></br>
### (B) After running above script, do following:

**(1) Add entry in crontab to run setgain.sh at boot as follows:** </br>
&nbsp; &nbsp; &nbsp; (a) Give command:  `sudo crontab -e ` </br>
&nbsp; &nbsp; &nbsp; (b) In file opened, scroll down and at bottom add following line </br>
&nbsp; &nbsp; &nbsp; `@reboot /bin/bash /usr/local/sbin/gain/setgain.sh `

**(2) After completing above step, Reboot Pi to start setgain script** </br>

**(3) Embedd "Set Gain" button into Skyview Map / Gmap** </br>
<details close>
<summary>dump1090-fa</summary>
</br>
3.1 - Make a backup copy of file index.html by following commands...
```
cd /usr/share/dump1090-fa/html
sudo cp index.html index.html.orig
# Check backup is created
ls index*
# Above command will list both files
index.html  index.html.orig
```    
3.2 - Open file index.html for editing </br>
    `sudo nano /usr/share/dump1090-fa/html/index.html ` </br>
 </br>
 Press Ctrl+W and type buttonContainer and press Enter key </br>
 the cursor will jump to `<div class="buttonContainer">` </br>
 add following 3 lines of code just above line `<div class="buttonContainer">` </br>
 </br>
 ```
<div id="GAIN" style="text-align:center;width:175px;height:65px;">
<iframe src=gain.php style="border:0;width:175px;height:65px;"></iframe>
</div> <!----- GAIN --->
```
</br>
3 - After completing steps 3.1 and 3.2, </br>
    (a) Reboot RPi </br>
    (b) After reboot, clear browser cache (Ctrl+Shift+Delete) and Reload Browser (Ctrl+F5) </br>
</details>

 <details close>
<summary>dump1090-mutability</summary>
</br>
3.1 - Make a backup copy of file gmap.html by following commands...
```
cd /usr/share/dump1090-mutability/html
sudo cp gmap.html gmap.html.orig
# Check backup is created
ls gmap*
# Above command will list both files
gmap.html  gmap.html.orig
```    
3.2 - Open file gmap.html for editing </br>
    `sudo nano /usr/share/dump1090-mutability/html/gmap.html ` </br>
 </br>
 Press Ctrl+W and type sudo_buttons and press Enter key </br>
 the cursor will jump to `<div class="sudo_buttons">` </br>
 add following 3 lines of code just above line `<div class="sudo_buttons">` </br>
 </br>
 ```
<div id="GAIN" style="text-align:center;width:175px;height:65px;">
<iframe src=gain.php style="border:0;width:175px;height:65px;"></iframe>
</div> <!----- GAIN --->
```
</br>
3 - After completing steps 3.1 and 3.2, </br>
    (a) Reboot RPi </br>
    (b) After reboot, clear browser cache (Ctrl+Shift+Delete) and Reload Browser (Ctrl+F5) </br>

</details>


