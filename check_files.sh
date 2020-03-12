#! /bin/bash
PATH_REMOTE=/home/gitlab-runner/
USER=gitlab-runner
HOST=172.20.23.161

declare -a dirs
i=1
for d in */
do
    dirs[i++]="${d%/}"
done
echo "There are ${#dirs[@]} dirs in the current path"

for((i=1;i<=${#dirs[@]};i++))
do
    ssh $HOST  "test -e $PATH_REMOTE/${dirs[i]}"
    if [ $? -eq 0 ]; then
        echo "File ${dirs[i]} exists"
    else
        echo "File ${dirs[i]} does not exist"
        tar zcvf - ${dirs[i]} | ssh $USER@$HOST "cat > $PATH_REMOTE/${dirs[i]}.tar.gz"


#    echo $i "${dirs[i]}"
#    echo  "${dirs[i]}"
done
