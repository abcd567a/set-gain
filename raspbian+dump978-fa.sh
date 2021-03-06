#!/bin/bash

echo -e "\e[32mUpdating apt......\e[39m"
sudo apt update

echo -e "\e[32mInstalling php-cgi....\e[39m"
sudo apt install -y php-cgi

# Before enabling module fastcgi-php, detect if package php-cgi is installed, 
# and if not, advise user to install it manually and exit script 
if [[ $(dpkg-query -W -f='${STATUS}' php-cgi 2>/dev/null | grep -c "ok installed") -eq 0 ]] ; then
  echo -e ""
  echo -e "\e[91m\e[5mINSTALLATION HALTED!\e[25m"
  echo -e "UNABLE TO INSTALL PACKAGE PHP-CGI."
  echo -e "SETUP HAS BEEN TERMINATED!"
  echo -e ""
  echo -e "\e[93mPlease install package php-cgi manually, then run this script again.\e[39m"
  echo -e ""
  exit 1
fi

echo ""
echo -e "\e[32mEnabling module fastcgi-php....\e[39m"
sudo lighty-enable-mod fastcgi-php
sudo /etc/init.d/lighttpd force-reload

echo "Creating file gain.php...."
FILE_GAIN="/usr/share/skyaware978/html/gain.php"
sudo touch $FILE_GAIN

echo "making file gain.php writeable by script (666)...."
sudo chmod 666 $FILE_GAIN

echo "Writing code to file gain.php...."
sudo cat <<\EOT > $FILE_GAIN

<html>
 <form id="myform" action="gain.php" method="post" />
 <div><font color=#ff0000 face="'Helvetica Neue', Helvetica, Arial, sans-serif">Current Gain: <?php system('cat /usr/local/sbin/gain978/currentgain');?> </font></div>
 <select name="gain" id="gain">
   <option value=49.6>49.6</option>
   <option value=48.0>48.0</option>
   <option value=44.5>44.5</option>
   <option value=43.9>43.9</option>
   <option value=43.4>43.4</option>
   <option value=42.1>42.1</option>
   <option value=40.2>40.2</option>
   <option value=38.6>38.6</option>
   <option value=37.2>37.2</option>
   <option value=36.4>36.4</option>
   <option value=33.8>33.8</option>
   <option value=32.8>32.8</option>
   <option value=29.7>29.7</option>
   <option value=28.0>28.0</option>
   <option value=25.4>25.4</option>
   <option value=22.9>22.9</option>
   <option value=20.7>20.7</option>
   <option value=19.7>19.7</option>
   <option value=16.6>16.6</option>
 </select>
 <input type="submit" value="Set Gain" style="color:#ffffff;background-color:#00A0E2;border-color:#00B0F0;" />
 </form>
</html>

<?php
function setgain(){
$gain="{$_POST['gain']}";
system("echo $gain > /usr/local/sbin/gain978/newgain");
sleep(10);
header("Refresh:0");
}

if ("{$_POST['gain']}"){
setgain();
}

?>


EOT

echo "Code written to file gain.php...."
echo " Making it writeable by owner only (664)...."
sudo chmod 644 $FILE_GAIN


echo "Creating folder gain...."
sudo mkdir -p /usr/local/sbin/gain978

echo "Creating file setgain.sh...."
FILE_SETGAIN="/usr/local/sbin/gain978/setgain.sh"
sudo touch $FILE_SETGAIN

echo "making file setgain.sh writeable by script (666)...."
sudo chmod 666 $FILE_SETGAIN


echo "Writing code to file setgain.sh...."
sudo cat <<\EOT > $FILE_SETGAIN

#!/bin/bash

#In file /etc/default/dump978-fa, check if double-quote already exists at the end of line starting with RECEIVER_OPTIONS
#If double-quote does not exist, add it.

if [[ $(grep RECEIVER /etc/default/dump978-fa | grep -o '.$') != \" ]]; then
     echo "double-quote at end of line NOT found, adding it...";
     sudo sed -i '/RECEIVER/ s/$/ \"/' /etc/default/dump978-fa
else
     echo "double-quote at the end of line found, do nothing"
fi

#Check if parameter --sdr-gain already exists or not
#If parameter --sdr-gain does not exist, add it
#If parameter --sdr-gain exist, add a space after last double-quote

if [[ $(grep -oe '--sdr-gain' /etc/default/dump978-fa) -eq 0 ]] ; then
     echo -e "\e[32--sdr-gain NOT found\e[39m";
     echo -e "\e[32adding --sdr-gain 45\e[39m";     
     sudo sed -i 's/RECEIVER_OPTIONS="/RECEIVER_OPTIONS="--sdr-gain 45 /' /etc/default/dump978-fa
else
     echo -e "\e[32--sdr-gain EXISTS....\e[39m";
     echo -e "\e[32inserting space befor last double-quote...\e[39m";
     sudo sed -i 's/\(.*\)"/\1 "/' /etc/default/dump978-fa
fi

#In file /etc/default/dump978-fa, compress multiple consecutive blank space to one space.
sudo sed -i 's/[[:blank:]]\{1,\}/ /g'  /etc/default/dump978-fa

# redirect all output and errors of this script to a log file
exec &>/usr/local/sbin/gain978/log

# file that anyone can write to in order to set a new gain
fifo978=/usr/local/sbin/gain978/newgain

# remove $fifo978 so we are sure we can create our named pipe
rm -f $fifo978

# create the named pipe with write access for everyone
mkfifo -m 666 $fifo978

#In file /etc/default/dump978-fa, compress multiple consecutive blank spaces to one space
sudo sed -i 's/[[:blank:]]\{1,\}/ /g'  /etc/default/dump978-fa

# read current gain and store in file currentgain
# script in gain.php will read gain value stored in currentgain and
# will display it on map as "Current Gain"
grep -oP '(?<=--sdr-gain )[^ ]*'  /etc/default/dump978-fa  > /usr/local/sbin/gain978/currentgain

while sleep 1
do
        if ! [[ -r $fifo978 ]] || ! [[ -p $fifo978 ]]

        # exit the loop/script if $fifo978 is not readable or not a named pipe
        then break
        fi

        #In file /etc/default/dump978-fa, compress multiple consecutive blank spaces to one space
        sudo sed -i 's/[[:blank:]]\{1,\}/ /g'  /etc/default/dump978-fa

        # read one line from the named pipe, remove all characters
        # but numbers, dot, minus and newline and store it in $line
        read line < <(tr -cd  '.\-0123456789\n' < $fifo978)

        #In file /etc/default/dump978-fa, compress multiple consecutive blank spaces to one space
        sudo sed -i 's/[[:blank:]]\{1,\}/ /g'  /etc/default/dump978-fa

        #set new gain
        gainnow=`sed -n 's/.*--sdr-gain \([^ ]*\).*/\1/p' /etc/default/dump978-fa`
        sudo sed -i 's/--sdr-gain '$gainnow'/--sdr-gain '$line'/' /etc/default/dump978-fa

        #restart dump978-fa to implement new gain value
        systemctl restart dump978-fa

        #In file /etc/default/dump978-fa, compress multiple consecutive blank spaces to one space
        sudo sed -i 's/[[:blank:]]\{1,\}/ /g'  /etc/default/dump978-fa

        # read updated gain and store in file currentgain
        grep -oP '(?<=--sdr-gain )[^ ]*'  /etc/default/dump978-fa  > /usr/local/sbin/gain978/currentgain
        # script in gain.php will read the gain updated by above command and display it on map

done


EOT

echo "code written to file setgain.sh...."
echo " Making it writeable by owner only (664)...."
sudo chmod 644 $FILE_SETGAIN

echo ""
echo ""
echo "FILE & FOLDER CREATION COMPLETED"
echo "FOLLOWING FILES ARE READY"
echo ""
echo $FILE_GAIN
echo $FILE_SETGAIN
echo ""
echo ""
echo -e "\e[32m==========================================\e[39m"
echo -e "\e[32mPLEASE DO FOLLOWING:\e[39m"
echo -e "\e[32m==========================================\e[39m"
echo -e "\e[32m(1) Add entry in crontab to run setgain.sh at boot.\e[39m"
echo "    Give command:  sudo crontab -e "
echo "    In file opened, scroll down and at bottom add following line"
echo ""
echo "    @reboot /bin/bash /usr/local/sbin/gain978/setgain.sh "
echo ""
echo -e "\e[32m(2) After completing above step, Reboot Pi to start setgain script\e[39m"
echo ""
echo -e "\e[32m(3) Make a backup copy of file index.html by following commands\e[39m"
echo ""
echo "    cd /usr/share/skyaware978/html  "
echo "    sudo cp index.html index.html.orig "
echo ""
echo -e "\e[32m(4) Open file index.html for editing \e[39m"
echo "    sudo nano /usr/share/skyaware978/html/index.html "
echo ""
echo "    Press Ctrl+W and type "buttonContainer" and press Enter key "
echo '    the cursor will jump to <div class="buttonContainer">'
echo '    add following 3 lines of code just above line <div class="buttonContainer">'
echo ""
echo '    <div id="GAIN" style="text-align:center;width:175px;height:65px;">'
echo '    <iframe src=gain.php style="border:0;width:175px;height:65px;"></iframe>'
echo '    </div> <!----- GAIN --->'
echo ""
echo -e "\e[32m(5) After completing steps (3) and (4), \e[39m"
echo "    (a) Reboot RPi "
echo "    (b) After reboot, clear browser cache (Ctrl+Shift+Delete) and Reload Browser (Ctrl+F5)"
echo ""
