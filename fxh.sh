#微信小程序一汽丰田丰享汇，域名https://wx.member.ftms.com.cn/yqftapi/weixin/customer/signpoints/today
#抓authorization和请求体中的customerid
#变量名fxhck值为authorization的值，变量名fxhid值为customerid的值
#by-莫老师，版本1.0
ck=($(echo $fxhck | sed 's/&/ /g'))
id=($(echo $fxhid | sed 's/&/ /g'))
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
syrq=$(($(echo "${ck[$s]}" | awk -F "." '{print $2}' | base64 -d | sed 's/,/\n/g' | grep "\"exp\"" | awk -F ":" '{print $2}')-$(date +%s)))
if [ "$syrq" -gt 0 ] && [ "$syrq" -lt 86400 ]; then
echo "丰享汇账号$s的ck将在24小时内失效"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"丰享汇账号'$s'的ck将24小时内失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
if [ "$syrq" -gt 0 ]; then
curl -s -X POST -H "Host: wx.member.ftms.com.cn" -H "Content-Length: 49" -H "authorization: ${ck[$s]}" -H "content-type: application/json" -H "ts: $(date +%Y%m%d%H%M%S)284" -d '{"customerid":"'${id[$s]}'"}' "https://wx.member.ftms.com.cn/yqftapi/weixin/customer/signpoints/today" -k | sed 's/,/\n/g' | grep "returnMsg" | awk -F ":" '{print $2}' | sed 's/\"//g'
else
echo "丰享汇账号$s的ck失效请重新抓"
curl -s -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"丰享汇账号'$s'的ck失效请重新抓","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message" -k | sed 's/,/\n/g' | grep "msg" | awk -F ":" '{print $2}'
fi
done