#! /bin/bash
set -e 

bfg(){
  java -jar /usr/bin/bfg.jar $@
}

gitdirname(){
  echo -n "$1" | rev | cut -d/ -f1 | rev | xargs echo
}

REPO="$(git config --get remote.origin.url)"
DIR_NAME="$(gitdirname "$REPO")"
cd $(mktemp -d)

cat << EOF > /tmp/passwords.txt
does.not.exist==>does.not.exist
does.not.exist==>does.not.exist
does.not.exist==>does.not.exist
uk-gov-dft==>uk-gov-dft
***REMOVED***
 ***REMOVED***
 ***REMOVED*** ***REMOVED***
 ***REMOVED***
 ***REMOVED***
regex:( ***REMOVED***)==>$1 ***REMOVED***
regex:(pass(:|=)\s?)[^\s]+==>$1 ***REMOVED***
regex:(password(:|=)\s?)[^\s]+==>$1 ***REMOVED***
regex:(apiKey(:|=)\s?)[^\s]+==>$1 ***REMOVED***
regex:(apikey(:|=)\s?)[^\s]+==>$1 ***REMOVED***
regex:([\w\-_]+secret.*)("|').*("|')==>$1 ***REMOVED***
regex:([\w\-_]+secret(:|=)\s?)[^\s]+==>$1 ***REMOVED***
***REMOVED***
 ***REMOVED***
regex:of.*' ***REMOVED***
regex:***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
- ***REMOVED***
EOF

cat << EOF > /tmp/repository.json
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

git clone --mirror "$REPO"
ls -la
cd "$DIR_NAME"

bfg --no-blob-protection --private --replace-text /tmp/passwords.txt  ./
git reflog expire --expire=now --all && git gc --prune=now --aggressive

curl -s -X POST -H "Authorization: Bearer $(cat ~/.ssh/github_token)" -d @/tmp/repository.json https://api.github.com/orgs/uk-gov-dft/repos

git remote add public "git@github.com:uk-gov-dft/bluebadge-$DIR_NAME"
git push public master

