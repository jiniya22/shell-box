: <<'END'
Jenkins를 이용하여 Spring Boot 앱을 Build한 후,
Jenkins가 설치된 서버에서 바로 deploy하는 예제
END

JENKINS_HOME=/var/lib/jenkins
pid=$(ps -eaf | grep demo.jar | grep -v "grep" | awk '{print $2}')

if [ "$pid" == "" ]; then
    echo "demo web application is not running."
else
    kill -9 $pid
    echo "demo web application process killed forcefully. (pid : $pid)"
fi

cd $JENKINS_HOME
if [ ! -d $JENKINS_HOME/deploys ]; then
    mkdir deploys
    echo "The deploys directory was created successfully."
fi
cd ./deploys

if [ ! -d demo ]; then
    mkdir demo
    echo "The demo directory was created successfully."
fi
cd ./demo

rm -rf ./backup/*
if [ ! -d backup ]; then
    mkdir backup
    echo "The backup directory was created successfully."
fi

if [ -e demo.jar ]; then
    mv demo.jar backup/
    echo "backup was successful."
fi

cp $JENKINS_HOME/workspace/demo/target/demo.jar demo.jar
BUILD_ID=dontKillMe nohup java -jar demo.jar 2>> /dev/null >> /dev/null &
echo $!