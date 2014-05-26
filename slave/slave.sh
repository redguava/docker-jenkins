#!/bin/bash

JENKINS_MASTER_IP=$(etcdctl --peers ${HOST}:4001 get /services/jenkins/master | egrep -v "Error: 100: Key not found|Cannot sync with the cluster" | grep -oP "(?<=\"host\": \")[^\"]+")
JENKINS_MASTER_PORT=$(etcdctl --peers ${HOST}:4001 get /services/jenkins/master | egrep -v "Error: 100: Key not found|Cannot sync with the cluster" | grep -oP "(?<=\"port\": \")[^\"]+")

curl -o slave.jar http://${JENKINS_MASTER_IP}:${JENKINS_MASTER_PORT}/jnlpJars/slave.jar
curl -d "name=${HOSTNAME}&type=hudson.slaves.DumbSlave&json=%7B%22${HOSTNAME}%22%3A+%22test%22%2C+%22nodeDescription%22%3A+%22%22%2C+%22numExecutors%22%3A+%221%22%2C+%22remoteFS%22%3A+%22%2F%22%2C+%22labelString%22%3A+%22%22%2C+%22mode%22%3A+%22NORMAL%22%2C+%22%22%3A+%5B%22hudson.slaves.JNLPLauncher%22%2C+%22hudson.slaves.RetentionStrategy%24Always%22%5D%2C+%22launcher%22%3A+%7B%22stapler-class%22%3A+%22hudson.slaves.JNLPLauncher%22%2C+%22tunnel%22%3A+%22%22%2C+%22vmargs%22%3A+%22%22%7D%2C+%22retentionStrategy%22%3A+%7B%22stapler-class%22%3A+%22hudson.slaves.RetentionStrategy%24Always%22%7D%2C+%22nodeProperties%22%3A+%7B%22stapler-class-bag%22%3A+%22true%22%7D%2C+%22type%22%3A+%22hudson.slaves.DumbSlave%22%7D&Submit=Save" http://${JENKINS_MASTER_IP}:${JENKINS_MASTER_PORT}/computer/doCreateItem
java -jar slave.jar -jnlpUrl http://${JENKINS_MASTER_IP}:${JENKINS_MASTER_PORT}/computer/${HOSTNAME}/slave-agent.jnlp
curl -d "json=%7B%7D&Submit=Yes" http://${JENKINS_MASTER_IP}:${JENKINS_MASTER_PORT}/computer/${HOSTNAME}/doDelete
