#app:MGlike，域名social.saicmg.com
#抓token和watch-man-token
#变量名mjck值为watch-man-token@token
#by-莫老师，版本1.1
zh=($(echo $mjck | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#zh[@]}-1)))
do
ck=$(echo ${zh[$s]} | awk -F "@" '{print $1}')
fk=$(echo ${zh[$s]} | awk -F "@" '{print $2}')
curl -o mj.json -s --http2 -X POST -H "Host: social.saicmg.com" -H "token: $ck" -H "watch-man-token: $fk" -H "content-type: application/json; charset=UTF-8" -H "content-length: 98" -d '{"token":"'$ck'","brandCode":"2","timestamp":"'$(date +%s)'696"}' "https://social.saicmg.com/api/energy/task/app/dailySignInV2?brandCode=2" -k
result=$(cat mj.json | sed 's/,/\n/g' | grep "resultCode" | awk -F ":" '{print $2}')
if [ "$result" = 200 ]; then
jf=$(cat mj.json | sed 's/,/\n/g' | grep "point" | awk -F ":" '{print $2}')
cj=$(cat mj.json | sed 's/,/\n/g' | grep "luckyDrawNum" | awk -F ":" '{print $2}')
echo "MGlike账号$s签到成功本次积分$jf，抽奖$cj"
else
echo "MGlike账号$s的ck失效请重新抓"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"MGlike账号'$s'的ck失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
done
rm -rf mj.json