#!/bin/bash

REPOSITORY=/home/ec2-user/app/step1
PROJECT=freelec-springboot2-webservice

cd $REPOSITORY/$PROJECT/

echo "> Git pull"

git pull

echo "> build"

./gradlew build

echo "> build 파일 복사"

cp $REPOSITORY/$PROJECT/build/libs/*.jar $REPOSITORY/

echo "> pid 확인"

CURRENT_PID=$(pgrep -f ${PROJECT}.*.jar)

echo " 현재 구동 중인 애플리케이션 pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
        echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
        echo "> kill -15 $CURRENT_PID"
        kill -15 $CURRENT_PID
        sleep 2

fi

echo "> 새 애플리케이션 배포"

JAR_NAME=$(ls -tr $REPOSITORY/ | grep jar | tail -n 1)

echo "> jar name : $JAR_NAME"

nohup java -Djava.security.egd=file:/dev/./urandom  -jar $REPOSITORY/$JAR_NAME 2>&1 &