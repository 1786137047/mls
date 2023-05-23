#!/bin/bash
#抓包比亚迪app，打开签到页面，抓这个链接dilinkappserver.byd.com/club/?service=ForInterfaceApp.forward&serviceDir=Sign.sign_day
#青龙创建环境变量，变量名bydck，值为刚才抓的链接请求中的request的参数，多个账号就创建多个变量。
#7.0以上的比亚迪APP可能抓不到包，建议下载旧版本抓
#by莫老师，版本1.5
ck=($(echo $bydck | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
zs=$(echo "${ck[$s]}" | awk '{print length($0)}')
length=$(($zs+14))
status=$(curl -s -X POST -H "Content-Type:application/json; charset=UTF-8" -H "Content-Length:$length" -H "Host:dilinkappserver.byd.com" -H "Connection:Keep-Alive" -H "Accept-Encoding:gzip" -H "User-Agent:okhttp/4.9.1" -d '{"request":"'${ck[$s]}'"}' "https://dilinkappserver.byd.com/club/?service=ForInterfaceApp.forward&serviceDir=Sign.sign_day" -k | sed 's/,/\n/g' | sed 's/\[/\n/g' |grep "status" | awk -F ":" '{print $2}' | sed 's/"//g' | sed 's/ //g')
if [ "$status" = 200 ]; then
echo "比亚迪账号$s的ck已失效"
curl -s -X POST -H "Host:wxpusher.zjiecode.com" -H "Content-Type:application/json" -d '{"appToken":"'$apptoken'","content":"比亚迪账号'$s'的ck已失效","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
else
echo "比亚迪账号$s签到成功"
fi
done
