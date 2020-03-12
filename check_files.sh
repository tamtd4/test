#! /bin/bash
BACKUP_PATH=/home/gitlab-runner/test
REMOTE_PATH=/home/gitlab-runner
USER=gitlab-runner
HOST=172.20.23.161

cd $BACKUP_PATH

declare -a dirs
i=1
for d in */
do
    dirs[i++]="${d%/}"
done
echo "There are ${#dirs[@]} dirs in the current path"

for((i=1;i<=${#dirs[@]};i++))
do
    echo $REMOTE_PATH/${dirs[i]}
    ssh $HOST  "test -e $REMOTE_PATH/${dirs[i]}.tar.gz"
    if [ $? -eq 0 ]; then
        echo "File ${dirs[i]}.tar.gz exists"
    else
        echo "File ${dirs[i]}.tar.gz does not exist"
        tar zcvf - ${dirs[i]} | ssh $USER@$HOST "cat > $REMOTE_PATH/${dirs[i]}.tar.gz"
    fi

        echo $i "${dirs[i]}"
#    echo  "${dirs[i]}"
done
