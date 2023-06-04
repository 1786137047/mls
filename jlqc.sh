#!/bin/bash
#抓包吉利汽车app，抓app.geely.com域名，抓token参数
#青龙创建环境变量，变量名jlck，值为刚才抓的token，多个账号就创建多个变量。
#by-莫老师，版本1.2
#cron:35 2 * * *
ck=($(echo $jlck | sed 's/&/ /g'))
url=app.geely.com
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
qd=$(curl -s --http2 -X POST -H "Host: $url" -H "content-length: 34" -H "token: ${ck[$s]}" -H "content-type:application/json" -d '{"signDate":"'$(date +%Y-%m-%d)' '$(date +%H:%M:%S)'"}' "https://$url/api/v1/userSign/sign" -k | sed 's/,/\n/g' | grep "message" | awk -F ":" '{print $2}' | sed 's/}//g' | sed 's/\"//g')
if [ "$qd" = token.unchecked ]; then
echo "吉利账号$s的ck失效请重新抓"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"吉利账号'$s'的ck失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
else
echo "吉利账号$s签到成功"
content=$(curl -s "https://v1.hitokoto.cn/?encode=text" -k)
length=$(($(echo "$content" | awk '{print length($0)}')+75))
ft=$(curl -s --http2 -X POST -H "Host: $url" -H "content-type: application/json; charset=UTF-8" -H "content-length: $length" -H "token: ${ck[$s]}" -d '{"circleId":null,"contentType":1,"content":"'$content'","fileList":[],"topicList":[]}' "https://$url/api/v2/topicContent/create" -k | sed 's/,/\n/g' | grep "data" | awk -F ":" '{print $2}' | sed 's/}//g' | sed 's/\"//g')
echo "吉林账号$s的积分为$(curl -s --http2 -X GET -H "Host: $url" -H "token: ${ck[$s]}" "https://$url/apis/api/v1/point/available" -k | sed 's/,/\n/g' | grep "availablePoint" | awk -F ":" '{print $3}' | sed 's/}//g' | sed 's/\"//g')"
sleep 30s
curl -s --http2 -X POST -H "Host: $url" -H "content-type: application/json; charset=UTF-8" -H "content-length: 28" -H "token: ${ck[$s]}" -d '{"id":"'$ft'"}' "https://$url/api/v2/topicContent/deleteContent" -k | sed 's/,/\n/g' | grep "message" | awk -F ":" '{print $2}' | sed 's/}//g' | sed 's/\"//g'
fi
done