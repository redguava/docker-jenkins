FROM redguava/centos
RUN yum install -y java-1.7.0-openjdk
RUN wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
RUN rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
RUN yum install -y jenkins
ADD config.xml /root/.jenkins/config.xml
EXPOSE 8080 8081
CMD /usr/bin/java -jar /usr/lib/jenkins/jenkins.war
