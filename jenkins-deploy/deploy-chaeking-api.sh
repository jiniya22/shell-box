: <<'END'
Jenkins를 이용하여 Spring Boot 앱을 Build한 후,
Build Artifacts를 SSH로 전송 후 deploy하는 예제
END

cd /usr/local/chaeking
base=$(pwd)

pid=$(ps -ef | grep "chaeking-api.jar" | grep -v "grep" | awk '{print $2}')

if [[ $pid == "" ]]
then
  echo "chaeking-api is not running."
else
  sudo kill -9 $pid
fi


if [ ! -d deploys ]; then
    mkdir deploys
    echo "The deploys directory was created successfully."
fi
cd ./deploys

if [ ! -d chaeking-api ]; then
    mkdir chaeking-api
    echo "The chaeking-api directory was created successfully."
fi
cd ./chaeking-api

rm -rf ./backup/*
if [ ! -d backup ]; then
    mkdir backup
    echo "The backup directory was created successfully."
fi

if [ -e chaeking-api.jar ]; then
    mv chaeking-api.jar backup/
    echo "backup was successful."
fi

mv $base/chaeking-api.jar chaeking-api.jar
chmod 764 chaeking-api.jar
nohup java -jar chaeking-api.jar 2>> /dev/null >> /dev/null &
echo $!