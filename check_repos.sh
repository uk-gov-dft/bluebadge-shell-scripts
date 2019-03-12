for i in $(bash list-github-repos.sh uk-gov-dft); do echo "Scanning $i" && trufflehog --entropy 0  --regex $i; done;
