#!/bin/sh

: "${AWS_ACCESS_KEY_ID:?Need to set AWS_ACCESS_KEY_ID non-empty}"
: "${AWS_SECRET_ACCESS_KEY:?Need to set AWS_SECRET_ACCESS_KEY non-empty}"
: "${SQS_QUEUE_URL:?Need to set SQS_QUEUE_URL non-empty}"

MESSAGES=$(aws sqs receive-message --queue-url $SQS_QUEUE_URL)

if [ -z "$MESSAGES" ]
then
	echo "No messages"
	exit 1
fi

MESSAGE_ID=$(echo $MESSAGES | jq -r .Messages[0].MessageId)
DOCKER_REPO=$(echo $MESSAGES | jq -r .Messages[0].Body)
RECEIPT_HANDLE=$(echo $MESSAGES | jq -r .Messages[0].ReceiptHandle)

EXISTING_CONTAINERS=$(docker ps -qf ancestor=$DOCKER_REPO)

echo "Received message with ID: $MESSAGE_ID"

echo "> docker pull $DOCKER_REPO"
docker pull $DOCKER_REPO | grep "newer image"

if [ $? -eq 0 ] && [ -z "$EXISTING_CONTAINERS" ]
then
	echo "Found newer version"
	echo "> docker stop $EXISTING_CONTAINERS"
	docker stop $EXISTING_CONTAINERS
fi

echo "> aws sqs delete-message --queue-url $SQS_QUEUE_URL --receipt-handle $RECEIPT_HANDLE"
aws sqs delete-message --queue-url $SQS_QUEUE_URL --receipt-handle $RECEIPT_HANDLE
