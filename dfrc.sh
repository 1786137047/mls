#!/bin/bash
#抓包小程序东风日产，域名community.dongfeng-nissan.com.cn抓authorization的值
#青龙创建环境变量，变量名dfrcck，值为刚才抓的eyJ0e开头的代码，多个账号就创建多个变量
#每日任务积分有限，最好定时0点做，ck有效期约两周
#by-莫老师，更新日期2023-05-21，版本2.2
ck=($(echo $dfrcck | sed 's/&/ /g'))
url=community.dongfeng-nissan.com.cn
if [ ! -f "testtzid" ]; then
echo $[$RANDOM%200000+1000000] >testtzid
fi
getid(){
testtzid=$(cat testtzid)
msg=$(echo -e $(curl -s -X GET -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" "https://$url./api/v2/feeds/$testtzid" -k) | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')
if [ "$msg" = 获取成功 ]; then
tzid=$testtzid
let testtzid++
echo $testtzid >testtzid
else
let testtzid++
echo $testtzid >testtzid
getid
fi
}
gz(){
msg=$(echo -e $(curl -s -X PUT -H "Host: $url" -H "Content-Length: 16" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d '{"isToast":true}' "https://$url/api/v2/user/followings/$[$RANDOM%200000+1000]" -k) | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')
if [ "$msg" = 关注成功 ]; then
echo "日产账号$s关注成功"
else
gz
fi
}
jq(){
msg=$(echo -e $(curl -s -X PUT -H "Host: $url" -H "Content-Length: 2" -H "authorization: Bearer ${ck[$s]}" -H "accept: application/json" -d "{}" "https://$url/api/v2/user/feed-topics/$[$RANDOM%58+1]" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g'))
if [ "$msg" = 申请成功 ]; then
echo "日产账号$s加圈成功"
else
jq
fi
}
pl(){
comment=$(curl -s "https://v1.hitokoto.cn/?encode=text" -k)
length=$(($(echo "$comment" | awk '{print length($0)}')+77))
msg=$(echo -e "$(curl -s -X POST -H "Host: $url" -H "Content-Length: $length" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d '{"commentable_type":"feeds","commentable_id":'$tzid',"body":"'$comment'","from_type":3}' "https://$url/api/v2/comments" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')")
if [ "$msg" = 评论成功 ]; then
echo "日产账号$s第$i次评论成功"
else
sleep $[$RANDOM%10]s
pl
fi
}
ft(){
title=$(echo ${yy[$c]} | awk -F "," '{print $1}')
content=$(echo ${yy[$c]} | awk -F "," '{print $2}')
if [ -z "$title" ]; then
title=每日一言
fi
length=$(($(echo $content$title | awk '{print length($0)}')+125))
msg=$(echo -e "$(curl -s -X POST -H "Host: $url" -H "Content-Length: $length" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d '{"feed_title":"'$title'","feed_content":"<p>'$content'</p>","feed_from":3,"themes":[],"feed_mark":'$(date +%s)'850,"feeds_type":2,"location":null}' "https://$url/api/v2/feeds" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')")
if [ "$msg" = 发布成功 ]; then
echo "日产账号$s第$y次发帖成功"
else
sleep $[$RANDOM%10]s
ft
fi
}
if [ "$(date +%d)" -eq 16 ]; then
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"日产账号抽奖次数今日将会清零，请尽快登录小程序，使用抽奖次数","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
for s in $(seq 1 ${#ck[@]})
do
curl -s -o yy.json -X POST -H "content-type: application/x-www-form-urlencoded" -H "Content-Length: 65" -H "Host: app.yiyan.art" -d "appId=1072099&accessKey=cccae96315acd0c9ea9a78ae0ccffb5c&random=1" "https://app.yiyan.art/yiyan/minipro" -k
contents=($(cat yy.json | sed 's/,/\n/g' | grep '\"content\"' | awk -F ":" '{print $2}' | sed 's/\"//g' | sed 's/}//g' | sed 's/]//g' | sed 's/\\n//g' | sed 's/ /，/g'))
titles=($(cat yy.json | sed 's/,/\n/g' | grep '\"from\"' | awk -F ":" '{print $2}' | sed 's/\"//g' | sed 's/}//g' | sed 's/]//g' | sed 's/\\n//g' | sed 's/ /，/g'))
for i in $(seq 0 1 3)
do
echo "${titles[$i]},${contents[$i]}" >>yy
done
done
yy=($(cat yy | sed 's/\n/ /g'))
rm -rf yy
c=0
for y in $(seq 1 3)
do
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
syrq=$(($(echo "${ck[$s]}" | awk -F "." '{print $2}' | base64 -d | sed 's/,/\n/g' | grep "exp" | awk -F ":" '{print $2}')-$(date +%s)))
if [ "$syrq" -gt 0 ] && [ "$syrq" -lt 86400 ]; then
echo "日产账号$s的ck将在24小时内失效"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"日产账号'$s'的ck将24小时内失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
if [ "$syrq" -gt 0 ]; then
ft
let c++
else
echo "日产账号$s的ck失效请重新抓"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"日产账号'$s'的ck失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
done
wait
done
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
for i in $(seq 1 5)
do
getid
pl
echo -e "日产账号$s第$i次$(curl -s -X POST -H "Host: $url" -H "authorization: Bearer ${ck[$s]}" -H "content-type: application/json" -d "" "https://$url/api/v2/feeds/$tzid/like" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')"
done
gz
jq
done