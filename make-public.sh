
REPO="$(git config --get remote.origin.url)"

cd $(mktemp -d)

gitdirname(){
  echo -n "$1" | rev | cut -d/ -f1 | rev | sed 's/\.git//g'| xargs echo
}

git clone "$REPO"

DIR_NAME="$(gitdirname "$REPO")"

echo "DIR_NAME=$DIR_NAME"

cd "$DIR_NAME"
git checkout master

gitleaks -v --repo-path ./

list-vulns-current

for i in `git rev-list --all`;
  do git grep -E "( ***REMOVED*** $i; 
done;

cat << EOF > /tmp/repository
{
  "name": "bluebadge-$DIR_NAME",
  "description": "bluebadge-$DIR_NAME",
  "homepage": "https://github.com",
  "private": false,
  "has_issues": false,
  "has_projects": false,
  "has_wiki": false
}
EOF

read -r -p "Are you sure you want to publish the current state? [y/N] " response
case "$response" in
  [yY][eE][sS]|[yY]) 

    curl -s -X POST -H "Authorization: Bearer $(cat ~/.ssh/github_token)" -d @/tmp/repository https://api.github.com/orgs/uk-gov-dft/repos


    git remote add public "git@github.com:uk-gov-dft/bluebadge-$(gitdirname "$REPO").git"

    git remote -v

    git push public master
    ;;
  *)
    echo "Aborting"
    ;;
esac
