# ./add_label.sh　
#!/bin/sh
data=`gh pr view --json author,headRefName,assignees --jq .author.name,.headRefName,.assignees[].name`
labels=`gh pr view --json labels --jq .labels[].name`

# dataで取得した情報を変数に格納
set ${data}
author=${1}
branch=${2}
assignees=${3}

# PR作成者を自動アサイン
if [[ "$assignees" == "" ]]; then
    echo "assigne" $author
    gh pr edit --add-assignee $author
fi

set ${labels}
attachlabels=("bug" "docs" "refactoring" "enhancement")
# ブランチ名にそってラベル付与
for name in ${attachlabels[@]}
do
if [[ $branch == *$name* ]]; then
    if printf '%s\n' "${labels[@]}" | grep -qx $name; then
        echo $name "label is already attached"
    else
        echo "attach" $name "label"
        gh pr edit --add-label $name
    fi
fi
done