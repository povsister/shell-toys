#!/bin/bash
BASE=$(dirname $0)

cd "$BASE"
source ./common.sh
source ./sea.common.sh

#BH3='https://api-takumi.mihoyo.com/post/wapi/getForumPostList?gids=1&forum_id=1&is_hot=false&is_good=false&sort_type=2&page_size=10'
YS='https://api-os-takumi.mihoyo.com/community/post/api/forumPostList?gids=2&forum_id=1&show_en=true&sort=create&page_size=10'
#DBY='https://api-takumi.mihoyo.com/post/wapi/getForumPostList?gids=5&forum_id=34&is_hot=false&is_good=false&sort_type=2&page_size=10'


getPosts() {
  httpGet $1 | jq -r '.data.posts[].post.post_id'
}


ARR=($YS)

for f in $ARR; do

  posts=$(getPosts $f)
  echo "Newly post threads: $posts"

  for p in ${posts}; do
    echo "Collect & Like: $p"
      httpGet "https://api-os-community.mihoyo.com/communityos/forum/post/assessPost?gids=2&post_id=${p}&access=book"
      httpGet "https://api-os-community.mihoyo.com/communityos/forum/post/assessPost?gids=2&post_id=${p}&cancel=1&access=book"
      # httpPost "https://api-os-takumi.mihoyo.com/community/apihub/api/collectPost" "{\"post_id\":${p}, \"is_cancel\": 1}"
      httpPost "https://api-os-takumi.mihoyo.com/community/apihub/api/upvotePost" "{\"post_id\":${p}}"
      httpPost "https://api-os-takumi.mihoyo.com/community/apihub/api/upvotePost" "{\"post_id\":${p}, \"is_cancel\": true}"
    echo ""
  done

done
