#!/bin/bash
BASE=$(dirname $0)

cd "$BASE"
source ./common.sh

BH3='https://api-takumi.mihoyo.com/post/wapi/getForumPostList?gids=1&forum_id=1&is_hot=false&is_good=false&sort_type=2&page_size=10'
YS='https://api-takumi.mihoyo.com/post/wapi/getForumPostList?gids=2&forum_id=26&is_hot=false&is_good=false&sort_type=2&page_size=10'
DBY='https://api-takumi.mihoyo.com/post/wapi/getForumPostList?gids=5&forum_id=34&is_hot=false&is_good=false&sort_type=2&page_size=10'


getPosts() {
  httpGet $1 | jq -r '.data.list[].post.post_id'
}

for f in $BH3 $YS $DBY; do

  posts=$(getPosts $f)
  echo "Newly post threads: $posts"

  for p in ${posts}; do
    echo "Collect & Like: $p"
      httpPost "https://api-takumi.mihoyo.com/post/wapi/collectPost" "{\"post_id\":${p}}"
      httpPost "https://api-takumi.mihoyo.com/post/wapi/collectPost" "{\"post_id\":${p}, \"is_cancel\": 1}"
      httpPost "https://api-takumi.mihoyo.com/apihub/api/upvotePost" "{\"post_id\":${p}}"
      httpPost "https://api-takumi.mihoyo.com/apihub/api/upvotePost" "{\"post_id\":${p}, \"is_cancel\": true}"
    echo ""
  done

done
