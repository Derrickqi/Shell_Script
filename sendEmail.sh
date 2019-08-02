#!/bin/bash

#Information
Send_User='xxxxxx@163.com'
Password='xxxxxxxxx'
Receive_User='xxxxxxxx@qq.com'
Title=$1
Content=$2



#Main Command
sendEmail -f $Send_User -t $Receive_User -s smtp.163.com -u $Title -o message-content-type=html -o message-charset=utf8 -xu $Send_User -xp $Password -m $Content




