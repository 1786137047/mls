#!/bin/bash
#微信小程序农耙耙，微信登录，要在个人中心绑定手机号，绑定完了之后找回密码
#青龙填写变量npp，值为手机号@密码，多个账号就创建多个变量
#by-莫老师，版本1.1
ua="Mozilla/5.0 (Linux; Android 13; RMX2202 Build/TP1A.220905.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/107.0.5304.141 Mobile Safari/537.36 XWEB/5061 MMWEBSDK/20230405 MMWEBID/5817 MicroMessenger/8.0.35.2360(0x28002357) WeChat/arm64 Weixin NetType/WIFI Language/zh_CN ABI/arm64 MiniProgramEnv/android"
url=sc.gdzfxc.com
zh=($(echo $npp | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#zh[@]}-1)))
do
user=$(echo ${zh[$s]} | awk -F "@" '{print $1}')
pass=$(echo ${zh[$s]} | awk -F "@" '{print $2}')
ck=$(curl -s -X POST -H "Host: $url" -H "Content-Length: 60" -H "User-Agent: $ua" -H "content-type: application/json" -d '{"tel":"'$user'","pwd":"'$pass'","logintype":1,"pid":0}' "https://$url/?s=%2FApiIndex%2Floginsub&aid=1&platform=wx&session_id=&pid=0" -k | sed 's/\"//g' | sed 's/,/\n/g' | grep "session_id" | awk -F ":" '{print $2}')
echo "农耙耙账号$s签到获得$(curl -s -X POST -H "Host: $url" -H "User-Agent: $ua" -H "content-type: application/json" -d "" "https://$url/?s=%2FApiSign%2Fsignin&aid=1&platform=wx&session_id=$ck&pid=0" -k | sed 's/}//g' | sed 's/,/\n/g' | grep "scoreadd" | awk -F ":" '{print $2}')积分"
for i in 1 2 3 10
do
length=$(($(echo $i | awk '{print length($0)}')+13))
echo "农耙耙账号$s任务$i获得$(curl -s -X POST -H "Host: $url" -H "User-Agent: $ua" -H "Content-Length: $length" -H "content-type: application/json" -d '{"renwu_id":'$i'}' "https://$url/?s=%2FApiSign%2FvideoRenwu&aid=1&platform=wx&session_id=$ck&pid=0" -k | sed 's/}//g' | sed 's/,/\n/g' | grep "scoreadd" | awk -F ":" '{print $2}')积分"
done
echo "农耙耙账号$s目前积分为$(curl -s -X POST -H "Host: $url" -H "User-Agent: $ua" -H "Content-Length: 20" -H "content-type: application/json" -d '{"st":0,"pagenum":1}' "https://$url/?s=/ApiMy/scorelog&aid=1&platform=wx&session_id=$ck&pid=0" -k | sed 's/}//g' | sed 's/,/\n/g' | grep "myscore" | awk -F ":" '{print $2}')"
done