#!/bin/bash
#抓包红旗智联app，新用户最好走邀请链接，有100积分，价值5元，别直接下载注册浪费了
#下载注册后抓hqapp.faw.cn域名，抓Authorization和aid两个参数。
#青龙创建环境变量，变量名hqck，值为aid@Authorization，多个账号就创建多个变量
#一天19分，一分价值0.05
#by-莫老师，版本2.0
#cron:35 5 * * *
zh=($(echo $hqck | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#zh[@]}-1)))
do
ck=$(echo ${zh[$s]} | awk -F "@" '{print $2}')
aid=$(echo ${zh[$s]} | awk -F "@" '{print $1}')
syrq=$(($(echo "$ck" | awk -F "." '{print $2}' | base64 -d | sed 's/,/\n/g' | grep "\"exp\"" | awk -F ":" '{print $2}')-$(date +%s)))
if [ "$syrq" -gt 0 ] && [ "$syrq" -lt 86400 ]; then
echo "红旗账号$s的ck将在24小时内失效"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"红旗账号'$s'的ck将24小时内失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
if [ "$syrq" -gt 0 ]; then
echo "红旗账号$s开始执行"
for i in $(seq 2 1 4)
do
curl -s -X POST -H "Authorization: $ck" -H "platform: 2" -H "aid: $aid" -H "Content-Type: application/json" -H "Content-Length: 17" -H "Host: hqapp.faw.cn" -d '{"scoreType":"'$i'"}' "https://hqapp.faw.cn/fawcshop/collect-public/v1/score/addScore" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
done
content=$(curl -s "https://v1.hitokoto.cn/?encode=text" -k)
length=$(($(echo "$content" | awk '{print length($0)}')+56))
tzid=$(curl -s -X POST -H "Authorization: $ck" -H "platform: 2" -H "aid: $aid" -H "Content-Type: application/json" -H "Content-Length: $length" -H "Host: hqapp.faw.cn" -d '{"province":"福建省","city":"福州市","content":"'$content'"}' "https://hqapp.faw.cn/fawcshop/collect-sns/v1/dynamicTopic/saveDynamicInfoImgUrl" -k | sed 's/,/\n/g' | grep "\"id\"" | awk -F ":" '{print $2}')
echo "帖子id是$tzid"
for i in $(seq 1 2)
do
comment=$(curl -s "https://v1.hitokoto.cn/?encode=text" -k)
length=$(($(echo "$comment$tzid" | awk '{print length($0)}')+88))
curl -s -X POST -H "Host: hqapp.faw.cn" -H "Content-Length: $length" -H "platform: 2" -H "Authorization: $ck" -H "aid: $aid" -H "Content-Type: application/json" -d '{"commentContext":"'$comment'","commentType":"8500","contentId":"'$tzid'","parentId":"0","fileString":[]}' "https://hqapp.faw.cn/fawcshop/collect-sns/v1/dynamicTopic/saveCommentDetailsRevision" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
done
content=$(curl -s "https://v1.hitokoto.cn/?encode=text" -k)
length=$(($(echo "$content" | awk '{print length($0)}')+63))
curl -s -X POST -H "Authorization: $ck" -H "platform: 2" -H "aid: $aid" -H "Content-Type: application/json" -H "Content-Length: $length" -H "Host: hqapp.faw.cn" -d '{"catalogId":1552,"seriesCode":"all","userType":1,"content":"'$content'"}' "https://hqapp.faw.cn/fawcshop/collect-qa/v2/QACenter/saveQuestionsDetailRevision" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
curl -s -o hq.json -X POST -H "Authorization: $ck" -H "platform: 2" -H "aid: $aid" -H "Content-Type: application/json" -H "Content-Length: 32" -H "Host: hqapp.faw.cn" -d '{"userId":"'$aid'"}' "https://hqapp.faw.cn/fawcshop/mall/v1/apiCus/getUserInfo" -k
echo "红旗账号$(cat hq.json | sed 's/,/\n/g' | grep "mobile" | awk -F ":" '{print $2}')目前积分$(cat hq.json | sed 's/,/\n/g' | grep "scoreCount" | awk -F ":" '{print $2}')"
else
echo "红旗账号$s的authorization失效请重新抓"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"红旗账号'$s'的authorization失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
done
rm -rf hq.json
