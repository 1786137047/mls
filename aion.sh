#app:埃安，域名www.gacne.com.cn
#抓PHPSESSID
#变量名aack值为PHPSESSID的值
#by莫老师，版本1.0
#cron:35 0 * * *
ck=($(echo $aack | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
msg=$(curl -s -X POST -H "Host: www.gacne.com.cn" -H "Content-Length: 40" -H "Content-Type: application/json" -H "Cookie: PHPSESSID=${ck[$s]}" -d '{"taskTypeCode":"TASK-INTEGRAL-SIGN-IN"}' "https://www.gacne.com.cn/newv1/lifemain/task-mapi/sign-in" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}' | sed 's/\"//g')
if [ -z "$msg" ]; then
echo "埃安账号$s签到成功"
else
echo "埃安账号$s的ck失效请重新抓"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"埃安账号'$s'的ck失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
done