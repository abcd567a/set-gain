## Read and Set Gain from maps of dump1090-fa / dump1090-mutability
|  |  |  |
|---|-|---|
| ![image](https://user-images.githubusercontent.com/28452511/160162763-512d0a9f-e50f-4350-9fbd-5d63c4153312.png)| |![image](https://user-images.githubusercontent.com/28452511/160232377-4aa9f42f-e354-4474-9446-d4ea3588a59d.png)  |




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
### (B) After running above script, the gain add on is available in browser as follows: </br>
**In dump1090-fa** at IP-of-Pi/skyaware/gain.php </br>
**In dump1090-mutability** at IP-of-Pi/dump1090/gain.php </br>

TThe set-gain app is started automatically at boot. It can also be started.stopped/status by following commands: </br>
`sudo systemctl status set-gain ` </br>
`sudo systemctl restart set-gain ` </br>
`sudo systemctl stop set-gain ` </br>

**(C) OPTIONAL: Embedd "Set Gain" button into Skyview Map / Gmap** </br>
<details close>
<summary>dump1090-fa (click to expand)</summary>
</br>
3.1 - Make a backup copy of file index.html by following commands:</br>


```
cd /usr/share/skyaware/html 
sudo cp index.html index.html.orig 
# Check backup is created
ls index* 
# Above command will list both files
index.html  index.html.orig
```    

</br>

3.2 - Open file index.html for editing </br>
    `sudo nano /usr/share/skyaware/html/index.html ` </br>
 </br>
 Press Ctrl+W and type buttonContainer and press Enter key </br>
 the cursor will jump to `<div class="buttonContainer">` </br>
 **Insert** following 3 lines of code **just ABOVE** the line `<div class="buttonContainer">` </br>
 </br>
 ```
<div id="GAIN" style="text-align:center;width:175px;height:65px;">
<iframe src=gain.php style="border:0;width:175px;height:65px;"></iframe>
</div> <!----- GAIN --->
```
</br>
3 - After completing above steps</br>
    (a) Save file (Ctrl+O) and close (ctrl+x)  </br>
    (b) Clear browser cache (Ctrl+Shift+Delete) and Reload Browser (Ctrl+F5) </br>

</details>

 <details close>
<summary>dump1090-mutability (click to expand)</summary>
</br>
3.1 - Make a backup copy of file gmap.html by following commands: </br>

```
cd /usr/share/dump1090-mutability/html
sudo cp gmap.html gmap.html.orig
# Check backup is created
ls gmap*
# Above command will list both files
gmap.html  gmap.html.orig
```    

</br>

3.2 - Open file gmap.html for editing </br>
    `sudo nano /usr/share/dump1090-mutability/html/gmap.html ` </br>
 </br>
 Press Ctrl+W and type sudo_buttons and press Enter key </br>
 the cursor will jump to `<div class="sudo_buttons">` </br>
 **Insert** following 3 lines of code **just ABOVE** the line `<div class="sudo_buttons">` </br>
 </br>
 ```
<div id="GAIN" style="text-align:center;width:175px;height:65px;">
<iframe src=gain.php style="border:0;width:175px;height:65px;"></iframe>
</div> <!----- GAIN --->
```
</br>
3 - After completing above steps</br>
    (a) Save file (Ctrl+O) and close (ctrl+x)  </br>
    (b) Clear browser cache (Ctrl+Shift+Delete) and Reload Browser (Ctrl+F5) </br>

</details>

</br>
</br>


## To Uninstall
<details close>
<summary>dump1090-fa (click to expand)</summary>
</br>

```
sudo systemctl stop set-gain  
sudo systemctl disable set-gain  
sudo rm /usr/lib/systemd/system/set-gain.service  
sudo rm /usr/share/skyaware/html/gain.php  
sudo rm -rf /usr/local/sbin/gain  
sudo lighty-disable-mod fastcgi-php  
sudo service lighttpd force-reload  

## Reboot Pi
sudo reboot

```

### To remove embedded gain button from Skyaware Map

![image](https://user-images.githubusercontent.com/28452511/160162763-512d0a9f-e50f-4350-9fbd-5d63c4153312.png)


If you have embeded gain button in Skyaware Map by modifying file `index.html` in folder `/usr/share/skyaware/html/` then it is easy to remove it.

**CASE-1: If you followed installation instructions and have created a backup copy `index.html.orig` before starting modifications:**

Copy backup file `index.html.orig` over modified file `index.html` by following commands:

```
cd /usr/share/skyaware/html/ 
sudo cp index.html.orig index.html   

## Reload Browser (Ctrl+F5)

```

**CASE-2: If you did not create a backup of file `index.html` before modifying it.**

Delete the 3 lines of code you have added to file index.html by following method:

(1) Open file index.html for editing

```
sudo nano /usr/share/skyaware/html/index.html
```

(2) Press Ctrl+W and type `buttonContainer` and press Enter key.
The cursor will jump to `<div class="buttonContainer">`
Delete following 3 lines of code you have added just above line `<div class="buttonContainer">`

```
    <div id="GAIN" style="text-align:center;width:175px;height:65px;">
    <iframe src=gain.php style="border:0;width:175px;height:65px;"></iframe>
    </div> <!----- GAIN --->
```

(3) Save & Close file `index.html` . Go to Skyaware Map and Reload browser (Ctrl+F5).

</details>

<details close>

<summary>dump1090-mutability (click to expand)</summary>
</br>

```
sudo systemctl stop set-gain  
sudo systemctl disable set-gain  
sudo rm /usr/lib/systemd/system/set-gain.service  
sudo rm /usr/share/dump1090-mutability/html/gain.php  
sudo rm -rf /usr/local/sbin/gain  
sudo lighty-disable-mod fastcgi-php  
sudo service lighttpd force-reload  

## Reboot Pi
sudo reboot

```

### To remove embedded gain button from GMap

![image](https://user-images.githubusercontent.com/28452511/160232377-4aa9f42f-e354-4474-9446-d4ea3588a59d.png)

If you have embeded gain button in GMap by modifying file `gmap.html` in folder `/usr/share/dump1090-mutability/html/` then it is easy to remove it.

**CASE-1: If you followed installation instructions and have created a backup copy `index.html.orig` before starting modifications:**

Copy backup file `gmap.html.orig` over modified file `gmap.html` by following commands:

```
cd /usr/share/dump1090-mutability/html/ 
sudo cp gmap.html.orig gmap.html   

## Reload Browser (Ctrl+F5)

```

**CASE-2: If you did not create a backup of file `gmap.html` before modifying it.**

Delete the 3 lines of code you have added to file gmap.html by following method:

(1) Open file gmap.html for editing

```
sudo nano /usr/share/dump1090-mutability/html/gmap.html
```

(2) Press Ctrl+W and type `sudo_buttons` and press Enter key.
The cursor will jump to `<div id="sudo_buttons">`
Delete following 3 lines of code you have added just above line `<div id="sudo_buttons">`

```
    <div id="GAIN" style="text-align:center;width:175px;height:65px;">
    <iframe src=gain.php style="border:0;width:175px;height:65px;"></iframe>
    </div> <!----- GAIN --->
```

(3) Save & Close file `gmap.html` . Go to GMap and Reload browser (Ctrl+F5).

</br>
</br>


