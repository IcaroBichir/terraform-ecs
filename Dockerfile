FROM tomcat:8.0-jre8

ADD ./target/servlet-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/servlet.war

ENV ENVIRONMENT=ENVIRONMENT_SETUP

CMD ["catalina.sh", "run"]
