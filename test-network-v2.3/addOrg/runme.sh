#! /bin/bash

# read me
# you can use this runme.sh to generate new organizations
# for example: if you want to create org7, you can just run "sh runme.sh 7"
# $1, which is the # of org, is the necessary parameter we need

sh updateFiles.sh $1
chmod +x ccp-generate$1.sh
./addOrg.sh up -ca -o $1
sh update_envVar.sh $1
sh update_setAnchorPeer.sh $1