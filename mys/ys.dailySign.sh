#!/bin/bash
BASE=$(dirname $0)

cd "$BASE"
source ./common.sh


REFERER='https://webstatic.mihoyo.com/bbs/event/signin-ys/index.html?bbs_auth_required=true&act_id=e202009291139501&utm_source=bbs&utm_medium=mys&utm_campaign=icon'
ORIGIN='https://webstatic.mihoyo.com'
UA="User-Agent: Mozilla/5.0 (Linux; Android 9.0.0; 16s; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/52.0.2743.100 Mobile Safari/537.36 miHoYoBBS/${APP_VERSION}"

cookies="myCookie kiraCookie"

for ck in ${cookies}; do
  COOKIE=${ck}
  verifyCookie
  # Put your UID in ./cookies/<cookieName>.UID as ysSignUID=XXXX
  source ./cookies/${ck}.UID
  ysSignBody='{"act_id":"e202009291139501","region":"cn_gf01","uid":"'$ysSignUID'"}'
  retry=0
  while true; do

    resp=$(appWebviewPost "https://api-takumi.mihoyo.com/event/bbs_sign_reward/sign" $ysSignBody)
    retcode=$(echo -n $resp|jq -r '.retcode')
    if [ "$retcode" == "0" -o "$retcode" == "-5003" ]; then
      echo "SignIn OK for $i. $resp"
      break
    fi

    if [ $retry -ge 5 ]; then
      echo "Retry limit. break"
      break
    fi
    retry=$((retry+1))
    echo "SignIn Failed for $i. retry $retry. $resp"
    sleep 3

  done
done


