# Pull base image 
#From tomcat:8-jre8
From ubuntu
ARG BRANCH_NAME=$BRANCH_NAME
#ENV BRANCH_NAME=$BRANCH_NAME
#COPY ./webapp/target/webapp.war /
#COPY ./webapp/target/webapp.war /usr/local/tomcat/webapps
#COPY ./webapp/target/webapp.war /opt/
COPY ./config/$BRANCH_NAME.properties /opt
CMD ['java', '-jar', './webapp/target/webapp.war /' /config/$BRANCH_NAME.properties]
RUN echo "$BRANCH_NAME" > /opt/aish.txt
#EXPOSE 8080
