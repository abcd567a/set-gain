#!/bin/bash

echo "Updating apt......"
sudo apt update


echo "Installing  package php5-cgi/php7.0-cgi ....."
CODENAME=`lsb_release -sc`
if [[ ${CODENAME} == "jessie" ]];
 then echo "Detected" ${CODENAME}". Installing php5-cgi....";
 sudo apt install -y php5-cgi;

elif [[ ${CODENAME} == "stretch" ]];
 then echo "Detected" ${CODENAME}". Installing php7.0-cgi....";
 sudo apt install -y php7.0-cgi;
fi

echo "Enabling module fastcgi-php...."
sudo lighty-enable-mod fastcgi-php
sudo /etc/init.d/lighttpd force-reload



echo "Creating file gain.php...."
FILE_GAIN="/usr/share/dump1090-motability/html/gain.php"
sudo touch $FILE_GAIN

echo "making file gain.php writeable by script (666)...."
sudo chmod 666 $FILE_GAIN

echo "Writing code to file gain.php...."
sudo cat <<\EOT > $FILE_GAIN

<html>
 <form id="myform" action="gain.php" method="post" />
 <div><font color=#ff0000 face="'Helvetica Neue', Helvetica, Arial, sans-serif">Current Gain: <?php system('cat /usr/local/sbin/gain/currentgain');?> </font></div>
 <select name="gain" id="gain">
   <option value=-10>-10</option>
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
system("echo $gain > /usr/local/sbin/gain/newgain");
sleep(5);
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
sudo mkdir -p /usr/local/sbin/gain

echo "Creating file setgain.sh...."
FILE_SETGAIN="/usr/local/sbin/gain/setgain.sh"
sudo touch $FILE_SETGAIN

echo "making file setgain.sh writeable by script (666)...."
sudo chmod 666 $FILE_SETGAIN


echo "Writing code to file setgain.sh...."
sudo cat <<\EOT > $FILE_SETGAIN

#!/bin/bash

# redirect all output and errors of this script to a log file
exec &>/usr/local/sbin/gain/log

# file that anyone can write to in order to set a new gain
fifo=/usr/local/sbin/gain/newgain

# remove $fifo so we are sure we can create our named pipe
rm -f $fifo

# create the named pipe with write access for everyone
mkfifo -m 666 $fifo

# read current gain and store in file currentgain
# script in gain.php will read gain value stored in currentgain and
# will display it on map as "Current Gain"
sed -n 's/\GAIN=//p' /etc/default/dump1090-mutability > /usr/local/sbin/gain/currentgain



while sleep 1
do
        if ! [[ -r $fifo ]] || ! [[ -p $fifo ]]

        # exit the loop/script if $fifo is not readable or not a named pipe
        then break
        fi


        # read one line from the named pipe, remove all characters but numbers, dot, minus and newline and store it in $line
        read line < <(tr -cd  '.\-0123456789\n' < $fifo)

        #set new gain
        sed -i '/GAIN=.*/c\GAIN='$line /etc/default/dump1090-mutability

        #restart dump1090-mutability to implement new gain value
        systemctl restart dump1090-mutability

        # read updated gain and store in file currentgain
        sed -n 's/\GAIN=//p' /etc/default/dump1090-mutability > /usr/local/sbin/gain/currentgain

        # script in gain.php will read the updated gain and display it on map

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
echo "PLEASE DO FOLLOWING:"
echo "(1) Edit file /usr/share/dump1090-mutability/html/index.html and add code"
echo "(2) Add entry in crontab to run setgain.sh at boot."
echo "(3) After completing above two steps, Reboot Pi"

