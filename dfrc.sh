#!/bin/bash
# 东风日产
#新用户请走邀请链接下载可得30积分https://oneapph5.dongfeng-nissan.com.cn/oneapp/inviteBindCar?urlData=2HuCYYTn5BB%2FrBQI%2FpKH%2FZX0VYSPsqBWb6opaO9uaizK9x%2BTGaECIC%2FHeRf19vcwyYNVb%2B%2BLgUaXXPPze5JfAg%3D%3D
#抓app，域名oneapph5.dongfeng-nissan.com.cn抓token的值
#青龙创建环境变量，变量名dfrcck值为token
#by-莫老师，v3.1
#cron:0 0 * * *
################################
ck=($(echo $dfrcck | sed 's/&/ /g'))
url=oneapph5.dongfeng-nissan.com.cn
if [ ! -f "testtzid" ]; then
echo $[$RANDOM%200000+1000000] >testtzid
fi
getid(){
testtzid=$(cat testtzid)
msg=$(echo -e $(curl -s -X GET -H "token: ${ck[$s]}" -H "Content-Type: application/json" -H "Host: $url" "https://$url/mb-gw/dndc-gateway/community/api/v2/feeds/$testtzid" -k) | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')
if echo "$msg" | grep -q "成功"; then
tzid=$testtzid
let testtzid++
echo $testtzid >testtzid
else
let testtzid++
echo $testtzid >testtzid
getid
fi
}
pl(){
comment=$(curl -s "https://v1.hitokoto.cn/?encode=text" -k)
length=$(($(echo "$tzid$comment" | awk '{print length($0)}')+58))
msg=$(echo -e "$(curl -s -X POST -H "token: ${ck[$s]}" -H "Content-Type: application/json" -H "Content-Length: $length" -H "Host: $url" -d '{"commentable_type":"feeds","commentable_id":"'$tzid'","body":"'$comment'"}' "https://$url/mb-gw/dndc-gateway/community/api/v2/comments" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')")
if echo "$msg" | grep -q "成功"; then
echo "日产账号$s第$i次$msg"
elif echo "$msg" | grep -q "无效"; then
echo "日产账号$s的ck失效请重新抓"
continue
fi
}
if [ "$(date +%d)" -eq 16 ]; then
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"日产账号抽奖次数今日将会清零，请尽快登录小程序，使用抽奖次数","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
msg=$(echo -e "$(curl -s -X GET -H "token: ${ck[$s]}" -H "Host: $url" "https://$url/mb-gw/dndc-gateway/community/api/v2/feed-themes/get_index" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')")
if echo "$msg" | grep -q "成功"; then
echo "日产账号$s$msg"
elif echo "$msg" | grep -q "无效"; then
echo "日产账号$s的ck失效请重新抓"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"日产账号'$s'的ck失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
done
for i in $(seq 4)
do
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
curl -s -o dfrc.json http://43.156.44.48/api/yy.php
title=$(cat dfrc.json | awk -F "," '{print $1}')
content=$(cat dfrc.json | awk -F "," '{print $2}')
length=$(($(echo $content$title | awk '{print length($0)}')+159))
msg=$(echo -e "$(curl -s -X POST -H "clientid: nissanapp" -H "token: ${ck[$s]}" -H "Content-Type: application/json" -H "Content-Length: $length" -H "Host: $url" -d '{"feed_mark":'$(date +%s)'000,"feed_title":"'$title'","themes":[],"feeds_type":2,"feed_from":2,"app_feed_content":[{"content":{"height":0,"text":"'$content'","width":0},"type":1}]}' "https://$url/mb-gw/dndc-gateway/community/api/v2/feeds" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')")
if echo "$msg" | grep -q "成功"; then
echo "日产账号$s第$i次$msg"
getid
pl
echo -e "日产账号$s第$i次$(curl -s -X POST -H "appVersion: 3.0.0" -H "token: ${ck[$s]}" -H "Content-Length: 2" -H "Host: $url" -d "{}" "https://$url/mb-gw/dndc-gateway/community/api/v2/feeds/$tzid/like" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')"
elif echo "$msg" | grep -q "无效"; then
echo "日产账号$s的ck失效请重新抓"
continue
fi
rm -rf *.json
done
wait
done
