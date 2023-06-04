#!/bin/bash
#抓包bbs.picovr.com，cookie中的sessionid值
#青龙创建环境变量，变量名picock，值为抓到的sessionid，多个账号则创建多个变量。
#by-莫老师，版本2.5
#cron:0 0 * * *

ck=($(echo $picock | sed 's/&/ /g'))
url=bbs.picovr.com
js=0
for i in $(seq 0 1 $((${#ck[@]}-1)))
do
{
echo "pico账号$i今日签到的积分为$(curl -s -X POST -H "Content-Length: 2" -H "Cookie: sessionid=${ck[$i]}" -H "Host: $url" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36" -H "Content-Type: application/json" -d "{}" "https://$url/ttarch/api/growth/v1/checkin/create?app_id=264482&web_id=7128273141759542820" -k | sed 's/,/\n/g' | grep "score" | awk -F ":" '{print $2}')"
}&
done
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
curl -s -o pico.json -X POST -H "content-type: application/x-www-form-urlencoded" -H "Content-Length: 65" -H "Host: app.yiyan.art" -d "appId=1072099&accessKey=cccae96315acd0c9ea9a78ae0ccffb5c&random=1" "https://app.yiyan.art/yiyan/minipro" -k
contents=($(cat pico.json | sed 's/,/\n/g' | grep '\"content\"' | awk -F ":" '{print $2}' | sed 's/\"//g' | sed 's/}//g' | sed 's/]//g' | sed 's/\\n//g' | sed 's/ /，/g'))
titles=($(cat pico.json | sed 's/,/\n/g' | grep '\"from\"' | awk -F ":" '{print $2}' | sed 's/\"//g' | sed 's/}//g' | sed 's/]//g' | sed 's/\\n//g' | sed 's/ /，/g'))
for i in $(seq 0 1 3)
do
echo "${titles[$i]},${contents[$i]}" >>yy
done
done
yy=($(cat yy | sed 's/\n/ /g'))
rm -rf yy
for i in $(seq 0 1 $((${#ck[@]}-1)))
do
echo "pico账号$i正在分享$(curl -s -X POST -H "Host: $url" -H "Content-Length: 9" -H "Cookie: sessionid=${ck[$i]}" -H "Content-Type: application/json; charset=UTF-8" -H "User-Agent: com.picovr.assistantphone/294 (Linux; U; Android 11; zh_CN; Mi 10; Build/RKQ1.200826.002; Cronet/TTNetVersion:3a37693c 2022-02-10 QuicVersion:775bd845 2021-12-24)" -d "body=null" "https://$url/ttarch/api/growth/v1/user/share?app_id=8641" -k | sed 's/,/\n/g' | grep "err_msg" | awk -F ":" '{print $2}' | sed 's/\"//g')"
title=$(echo ${yy[$js]} | awk -F "," '{print $1}')
content=$(echo ${yy[$js]} | awk -F "," '{print $2}')
let js++
if [ -z "$title" ]; then
title=每日一言
fi
length=$(($(echo $content$content$title | awk '{print length($0)}')+123))
echo "pico账号$i帖子id为$(curl -s -X POST -H "Host: $url" -H "Content-Length: $length" -H "Cookie: sessionid=${ck[$i]}" -H "Content-Type: application/json; charset=UTF-8" -H "User-Agent: com.picovr.assistantphone/294 (Linux; U; Android 11; zh_CN; Mi 10; Build/RKQ1.200826.002; Cronet/TTNetVersion:3a37693c 2022-02-10 QuicVersion:775bd845 2021-12-24)" -d '{"category_ids":["170"],"content":{"abstract":"'$content'","content":"'$content'","item_type":2,"mime_type":"html","name":"'$title'"},"need_publish":1}' "https://$url/ttarch/api/content/v1/content/create?app_id=8641" -k | sed 's/,/\n/g' | grep "item_id" | awk -F ":" '{print $3}' | sed 's/}//g' | sed 's/\"//g')"
ids=($(curl -s --http2 -X GET -H "Host:bbs.picoxr.com" "https://bbs.picoxr.com/ttarch/api/content/v1/content/list_by_pool_page?app_id=264482&page_size=20&page_index=27930&pool_type=0&category_id=170&item_type=2&sort_type=1&service_id=0&lang=zh-Hans-CN&web_id=7223551455834687014" -k | sed 's/,/\n/g' | sed 's/\[/\n/g' | grep "item_id" | grep "content" | awk -F ":"  '{print $3}' | sed 's/"//g'))
for p in $(seq 2)
do
comment=$(echo ${yy[$js]} | awk -F "," '{print $2}')
let js++
if [ -z "$comment" ]; then
comment=666666
fi
length=$(($(echo $comment${ids[$p]} | awk '{print length($0)}')+53))
echo "pico账号$i评论第$p次$(curl -s -X POST -H "Host: $url" -H "Content-Length: $length" -H "Cookie: sessionid=${ck[$i]}" -H "Content-Type: application/json; charset=UTF-8" -H "User-Agent: com.picovr.assistantphone/294 (Linux; U; Android 11; zh_CN; Mi 10; Build/RKQ1.200826.002; Cronet/TTNetVersion:3a37693c 2022-02-10 QuicVersion:775bd845 2021-12-24)" -d '{"comment":{"content":"'$comment'","item_id":"'${ids[$p]}'","item_type":2}}' "https://$url/ttarch/api/interact/v1/comment/create?app_id=8641" -k | sed 's/,/\n/g' | grep "err_no" | awk -F ":" '{print $2}' | sed 's/\"//g')"
sleep $[$RANDOM%60]s
done
curl -s -o pico.json -X GET -H "Host: $url" -H "Cookie: sessionid=${ck[$i]}" -H "User-Agent: com.picovr.assistantphone/294 (Linux; U; Android 11; zh_CN; Mi 10; Build/RKQ1.200826.002; Cronet/TTNetVersion:3a37693c 2022-02-10 QuicVersion:775bd845 2021-12-24)" "https://$url/ttarch/api/growth/v1/user/get?aid=8641" -k
err=$(cat pico.json | sed 's/,/\n/g' | sed 's/\[/\n/g' |grep "err_no" | awk -F ":" '{print $2}' | sed 's/"//g' | sed 's/}//g')
if [ "$err" = 0 ]; then
echo "pico账号$i的总积分为$(cat pico.json | sed 's/,/\n/g' | sed 's/\[/\n/g' |grep "point" | grep "growth_info" | awk -F ":" '{print $3}' | sed 's/"//g')"
else
echo "pico账号$i的ck已失效"
curl -s -X POST -H "Host:wxpusher.zjiecode.com" -H "Content-Type:application/json" -d '{"appToken":"'apptoken'","content":"pico账号'$i'的CK已失效","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k
fi
done
rm -rf pico.json