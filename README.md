# shell-scripts

## Database import script

```
pip install --user psycopg2
export DATABASE_URL="dbname='' user=''  ***REMOVED***
./import data.csv
```

## Scanning

```
for i in $(cat shell-scripts/public-projects.txt); do ~/devops-shell-scripts/scan_git_repo $i ; done;
```
