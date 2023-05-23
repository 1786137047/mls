#!/bin/bash
#抓包北京汽车app，抓beijing-gateway-customer.app-prod.bjev.com.cn域名，抓Authorization参数
#青龙创建环境变量，变量名bjck，值为刚才抓的eyJhb开头的代码，多个账号就创建多个变量。
#by-莫老师，更新日期2023-05-18，版本1.2

ck=($(echo $bjck | sed 's/&/ /g'))
rw=(ENTITY_LIKE GET_TASK_ATTENTION ENTITY_SHARE GET_TASK_LIKE)
url=beijing-gateway-customer.app-prod.bjev.com.cn
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
syrq=$(($(echo "${ck[$s]}" | awk -F "." '{print $2}' | base64 -d | sed 's/,/\n/g' | grep "\"exp\"" | awk -F ":" '{print $2}')-$(date +%s)))
if [ "$syrq" -gt 0 ] && [ "$syrq" -lt 86400 ]; then
echo "北京账号$s的ck将在24小时内失效"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"北京账号'$s'的ck将24小时内失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
if [ "$syrq" -gt 0 ]; then
echo "北京账号$s签到$(curl -s -X POST -H "User-Agent: (Android 13; Redmi 23049RAD8C Build/V14.0.16.0.TMRCNXM 3.5.0 123 release bjApp)" -H "Authorization: Bearer ${ck[$s]}" -H "Content-Type: application/json;charset=UTF-8" -H "Host: $url" -d "" "https://$url/beijing-zone-asset/exterior/userSignRecord/addSign" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}')"
content=$(curl -s "https://v1.hitokoto.cn/?encode=text" -k)
length=$(($(echo "$content" | awk '{print length($0)}')+69))
tzid=$(curl -s -X POST -H "User-Agent: (Android 13; Redmi 23049RAD8C Build/V14.0.16.0.TMRCNXM 3.5.0 123 release bjApp)" -H "Authorization: Bearer ${ck[$s]}" -H "Content-Type: application/json;charset=UTF-8" -H "Content-Length: $length" -H "Host: $url" -d '{"dynamicWords":"'$content'","id":0,"isEdit":false,"relationTopic":[],"type":2}' "https://$url/beijing-zone-dynamic/exterior/dynamic/add" -k | sed 's/,/\n/g' | grep "data" | awk -F ":" '{print $2}')
echo "帖子id是$tzid"
for d in $(seq 0 1 $((${#ck[@]}-1)))
do
curl -s -X POST -H "User-Agent: (Android 13; Redmi 23049RAD8C Build/V14.0.16.0.TMRCNXM 3.5.0 123 release bjApp)" -H "Authorization: Bearer ${ck[$d]}" -H "Content-Type: application/json;charset=UTF-8" -H "Content-Length: 29" -H "Host: $url" -d '{"entityId":'$tzid',"type":2}' "https://$url/beijing-zone-dynamic/exterior/interact/like" -k >/dev/null
done
for i in $(seq 1 10)
do
curl -s -X POST -H "User-Agent: (Android 13; Redmi 23049RAD8C Build/V14.0.16.0.TMRCNXM 3.5.0 123 release bjApp)" -H "Authorization: Bearer ${ck[$s]}" -H "Content-Type: application/json;charset=UTF-8" -H "Content-Length: 29" -H "Host: $url" -d '{"entityId":'$(($tzid-$i))',"type":2}' "https://$url/beijing-zone-dynamic/exterior/interact/like" -k >/dev/null
curl -s -X POST -H "User-Agent: (Android 13; Redmi 23049RAD8C Build/V14.0.16.0.TMRCNXM 3.5.0 123 release bjApp)" -H "Authorization: Bearer ${ck[$s]}" -H "Content-Type: application/json;charset=UTF-8" -H "Content-Length: 20" -H "Host: $url" -d '{"entityId":'$(($tzid-$i))'}' "https://$url/beijing-zone-dynamic/exterior/interact/dynamic/share" -k >/dev/null
done
else
echo "北京账号$s的authorization失效请重新抓"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"北京账号'$s'的authorization失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
done
sleep 30s
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
for l in $(seq 0 1 $((${#rw[@]}-1)))
do
length=$(($(echo "${rw[$l]}" | awk '{print length($0)}')+20))
curl -s -X POST -H "User-Agent: (Android 13; Redmi 23049RAD8C Build/V14.0.16.0.TMRCNXM 3.5.0 123 release bjApp)" -H "Authorization: Bearer ${ck[$s]}" -H "Content-Type: application/json;charset=UTF-8" -H "Content-Length: $length" -H "Host: $url" -d '{"taskGroupCode":"'${rw[$l]}'"}' "https://$url/beijing-zone-asset/exterior/userTaskProgress/receiveAward" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
done
echo "北京账号$s目前积分$(curl -s -X GET -H "Content-Type: application/json;charset=UTF-8" -H "User-Agent:(Android 13; Redmi 23049RAD8C Build/V14.0.16.0.TMRCNXM 3.6.0 125 release bjApp)" -H "Authorization: Bearer ${ck[$s]}" -H "Host: beijing-gateway-customer.app-prod.bjev.com.cn" "https://beijing-gateway-customer.app-prod.bjev.com.cn/beijing-zone-asset/exterior/user/integral/myIntegral" -k | sed 's/,/\n/g' | grep "availableIntegral" | awk -F ":" '{print $3}')"
done