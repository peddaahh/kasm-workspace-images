sudo dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -nr | head
df . -h
sudo du /usr/ -hx -d 4 --threshold=1G | sort -hr | head