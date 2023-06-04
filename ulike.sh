#!/bin/bash
#抓包ulike小程序，抓smp-api.iyouke.com域名，抓Authorization和appid两个参数。
#青龙创建环境变量，变量名ulike，值为appid@Authorization，多个账号就创建多个变量
#by-莫老师，版本1.2
#cron:35 7 * * *
zh=($(echo $ulike | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#zh[@]}-1)))
do
authorization=$(echo ${zh[$s]} | awk -F "@" '{print $2}')
appid=$(echo ${zh[$s]} | awk -F "@" '{print $1}')
qd=$(curl -s -X GET -H "Host: smp-api.iyouke.com" -H "authorization: $authorization" -H "appid: $appid" "https://smp-api.iyouke.com/dtapi/pointsSign/user/sign?date=$(date +%Y/%m/%d)" -k)
if [ "$qd" = token已失效 ]; then
echo "ulike账号$s的ck失效请重新抓"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"ulike账号'$s'的ck失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
else
echo "ulike$s签到成功"
fi
done