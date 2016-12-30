#!/bin/sh

: "${AWS_ACCESS_KEY_ID:?Need to set AWS_ACCESS_KEY_ID non-empty}"
: "${AWS_SECRET_ACCESS_KEY:?Need to set AWS_SECRET_ACCESS_KEY non-empty}"
: "${SQS_QUEUE_URL:?Need to set SQS_QUEUE_URL non-empty}"

MESSAGES=$(aws sqs receive-message --message-attribute-names All --max-number-of-messages 1 --queue-url $SQS_QUEUE_URL)

if [ -z "$MESSAGES" ]
then
	echo "No messages"
	exit 0
fi

MESSAGE_ID=$(echo $MESSAGES | jq -r .Messages[0].MessageId)
DOCKER_REPO=$(echo $MESSAGES | jq -r .Messages[0].MessageAttributes.repository.StringValue)
DOCKER_LABELS=$(echo $MESSAGES | jq -r .Messages[0].MessageAttributes.labels.StringValue)
RECEIPT_HANDLE=$(echo $MESSAGES | jq -r .Messages[0].ReceiptHandle)

EXISTING_CONTAINERS=$(docker ps -qf label=$DOCKER_LABELS)
docker ps -f label=$DOCKER_LABELS

echo "Received message with ID: $MESSAGE_ID"

echo "> docker pull $DOCKER_REPO"
docker pull $DOCKER_REPO

echo "> docker stop $EXISTING_CONTAINERS"
docker stop $EXISTING_CONTAINERS

echo "> aws sqs delete-message --queue-url $SQS_QUEUE_URL --receipt-handle $RECEIPT_HANDLE"
aws sqs delete-message --queue-url $SQS_QUEUE_URL --receipt-handle $RECEIPT_HANDLE
