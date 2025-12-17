FROM tomcat:9.0
COPY target/cloud-native-maven-app.war /usr/local/tomcat/webapps/
