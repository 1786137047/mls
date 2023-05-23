#!/bin/bash
#抓包东风雪铁龙app，抓这个域名gateway-sapp.dpca.com.cn
#青龙创建环境变量，变量名dfxtlck，值为刚才抓的链接请求Authorization的参数。
#ck7天有效，七天抓一次
#by-莫老师，版本1.4
dfxtlck=ISOFTSTONE.eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMzI5MDgwNzA2NyIsImF1dGgiOiIiLCJleHAiOjE2ODUwNzM3NDl9.qEgoEVJHpJGNqhWuXdspv0UJ4dqLDmEFyP8P33Vdsc5nXvs-zgFEV-Mq-P6jC2zq_YjQojO6eLAZt37xEsORSw
ck=($(echo $dfxtlck | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
syrq=$(($(echo "${ck[$s]}" | awk -F "." '{print $3}' | base64 -d | sed 's/,/\n/g' | sed 's/}//g' | grep "\"exp\"" | awk -F ":" '{print $2}')-$(date +%s)))
if [ "$syrq" -gt 0 ] && [ "$syrq" -lt 86400 ]; then
echo "东风雪铁龙账号$s的ck将在24小时内失效"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"东风雪铁龙账号'$s'的ck将24小时内失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
elif [ "$syrq" -lt 0 ]; then
echo "东风雪铁龙账号$s的authorization失效请重新抓"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"东风雪铁龙账号'$s'的authorization失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
user=$(curl -s -X GET -H "Authorization: ${ck[$s]}" -H "Sign: $RANDOM" -H "SourceApp: DC" -H "SourceType: ANDROID" -H "Content-Type: application/json" -H "SourceAppVer: 4.3.0" -H "TimeStamp: $(date +%s)000" -H "Host: gateway-sapp.dpca.com.cn" "https://gateway-sapp.dpca.com.cn/api-u/v1/user/info/get" -k | sed 's/,/\n/g' | grep "\"userId\"" | awk -F ":" '{print $2}' | sed 's/\"//g')
echo "雪铁龙账号$s签到$(curl -s -X GET -H "Authorization: ${ck[$s]}" -H "Sign: $RANDOM" -H "SourceApp: DC" -H "SourceType: ANDROID" -H "SourceAppVer: 4.3.0" -H "TimeStamp: $(date +%s)000" -H "Host: gateway-sapp.dpca.com.cn" "https://gateway-sapp.dpca.com.cn/api-u/v1/user/sign/sureNew?userId=$user" -k | sed 's/,/\n/g' | sed 's/\[/\n/g' | grep "message" | awk -F ":" '{print $2}' | sed 's/\"//g')"
echo "雪铁龙账号$s总积分为$(curl -s -X GET -H "Authorization: ${ck[$s]}" -H "Sign: $RANDOM" -H "SourceApp: DC" -H "SourceType: ANDROID" -H "SourceAppVer: 4.3.0" -H "TimeStamp: $(date +%s)000" -H "Host: gateway-sapp.dpca.com.cn" "https://gateway-sapp.dpca.com.cn/api-u/v1/user/score/get" -k | sed 's/,/\n/g' | grep "totalScore" | awk -F ":" '{print $3}' | sed 's/\"//g')"
done