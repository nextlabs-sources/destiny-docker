#!/bin/bash
CLUSTER_NAME=ecs-poc-demo
# mount efs
mkdir /mnt/efs
yum install -y amazon-efs-utils
# get file system ID using Name tag (assumption name tag = cluster name) using AWS CLI
echo ECS_CLUSTER=${CLUSTER_NAME} >> /etc/ecs/ecs.config
FILE_SYSTEM_ID=$(aws efs describe-file-systems --query 'FileSystems[*].[Name,FileSystemId]' --region=us-east-1  --output text | grep ${CLUSTER_NAME} | awk '{print $2}' )
echo "$FILE_SYSTEM_ID.efs.$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).amazonaws.com:/ /mnt/efs  nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab
mount /mnt/efs