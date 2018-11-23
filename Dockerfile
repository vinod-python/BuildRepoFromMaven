FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server python-minimal
RUN apt-get update && apt-get install -y openjdk-8-jdk-headless maven git
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
#RUN echo 'jenkins:jenkins' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile

COPY authorized_keys /root/.ssh/authorized_keys

#this opens port 22 for ssh and 80 for any web-servers(http)
EXPOSE 22
EXPOSE 80 

#configures ssh server as startup application when containers starts
CMD ["/usr/sbin/sshd", "-D"]
