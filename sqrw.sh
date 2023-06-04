#!/bin/bash
#app:上汽荣威，域名social.roewe.com.cn
#抓token和watch-man-token
#变量名rwck值为watch-man-token@token
#BY-莫老师，版本1.4
zh=($(echo $rwck | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#zh[@]}-1)))
do
ck=$(echo ${zh[$s]} | awk -F "@" '{print $1}')
fk=$(echo ${zh[$s]} | awk -F "@" '{print $2}')
echo -e "荣威账号$s抽卡$(curl -s --http2 -X GET -H "Host: game.roewe.com.cn" -H "token: ${ck[$s]}" -H "timestamp: $(date +%s)066" -H "watch-man-token: ${fk[$s]}" "https://game.roewe.com.cn/api/draw_lots/draw_card?user_token=${ck[$s]}&card_series_id=31" -k | sed 's/,/\n/g' | grep "name" | awk -F ":" '{print $2}')"
sleep $[$RANDOM%20]s
echo -e "荣威账号$s今日签到获得$(curl -s --http2 -X GET -H "Host: social.roewe.com.cn" -H "token: ${ck[$s]}" -H "timestamp: $(date +%s)536" -H "watch-man-token: ${fk[$s]}" "https://social.roewe.com.cn/api/energy/task/getRegisterInfoAppNew?token=${ck[$s]}" -k | sed 's/,/\n/g' | grep "checkPoint" | awk -F ":" '{print $2}')积分"
sleep $[$RANDOM%20]s
echo -e "荣威账号$s分享$(curl -s --http2 -X GET -H "Host: social.roewe.com.cn" -H "token: ${ck[$s]}" -H "timestamp: $(date +%s)552" -H "watch-man-token: ${fk[$s]}" "https://social.roewe.com.cn/api/news/news/app/forwardNews?businessId=5457" -k | sed 's/,/\n/g' | grep "resultCode" | awk -F ":" '{print $2}')"
sleep $[$RANDOM%20]s
tzid=($(curl -s --http2 -X POST -H "Host: social.roewe.com.cn" -H "token: ${ck[$s]}" -H "timestamp: $(date +%s)552" -H "watch-man-token: ${fk[$s]}" -H "content-type: application/json; charset=UTF-8" -H "content-length: 179" -d '{"searchType":"0","sortType":"1","limit":10,"businessType":"1020","sortValues":[],"token":"'${ck[$s]}'","brandCode":"1","timestamp":"'$(date +%s)'552"}' "https://social.roewe.com.cn/api/community/content/app/queryHallRecentContentList" -k | sed 's/,/\n/g' | sed 's/\[/\n/g' | grep "businessId" | awk -F ":" '{print $2}'))
user=$(curl -s --http2 -X GET -H "Host: social.roewe.com.cn" -H "token: ${ck[$s]}" -H "timestamp:  $(date +%s)684" -H "watch-man-token: ${fk[$s]}" "https://social.roewe.com.cn/api/community/user/app/getMyselfInfo?brandCode=1" -k | sed 's/,/\n/g' | grep "saicUserId" | awk -F ":" '{print $2}')
for i in $(seq 0 1 9)
do
length=$(($(echo ${ck[$s]}$user${tzid[$i]} | awk '{print length($0)}')+107))
curl -s --http2 -X POST -H "Host: social.roewe.com.cn" -H "token: ${ck[$s]}" -H "timestamp: $(date +%s)042" -H "watch-man-token: ${fk[$s]}" -H "content-type: application/json;charset=UTF-8" -H "content-length: $length" -d '{"phone":","'$user'","businessId":"'${tzid[$i]}'","businessType":"1007","token":"'${ck[$s]}'","brandCode":"1","timestamp":"'$(date +%s)'042"}' "https://social.roewe.com.cn/api/community/praise/add" -k | sed 's/,/\n/g' | grep "resultCode" | awk -F ":" '{print $2}'
sleep $[$RANDOM%20]s
done
done