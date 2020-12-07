#! /bin/bash

 #Change Java version to version from config
jdk="/usr/lib/jvm/java-$JAVA_VER-openjdk-amd64"

if [ -d "$jdk" ]; then
  sudo update-alternatives --install "/usr/bin/java" "java" $jdk"/bin/java" 1
  sudo update-alternatives --set "java" $jdk"/bin/java"
  echo "Java $JAVA_VER "
else
  echo "Java $JAVA_VER is not installed!"
  exit 1
fi


#Found outfile in work directory 
if [ ! -e $OUTFILE ]; then
  touch $OUTFILE
  echo "Created the outfile"
fi

if [ -w $OUTFILE ]; then
  chmod +w $OUTFILE
fi

#run main application
old_pid_java=$(pgrep -n java)

(java -jar /home/zae/app.jar $OUTFILE "App is running on Java $JAVA_VER!")&

#If app is not running
if [ "$(pgrep -n java)" == "$old_pid_java" ]; then
  echo "Error, app is not running"
  exit 1
fi

#If app running after 5 second
sleep 5

if [ "$(pgrep -n java)" != "$old_pid_java" ]; then
  echo "Applicatin is up of 5 second. PID: $(pgrep -n java). Success!"
fi
