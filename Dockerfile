FROM ubuntu:16.04
MAINTAINER Sinan Goo

#
# RUN apt-get update && \
#     apt-get upgrade -y && \
#     apt-get install -y openssh-server && \
#     mkdir /var/run/sshd
#
# RUN echo root:root | chpasswd
# EXPOSE 22
# CMD ["/usr/sbin/sshd", "-D"]

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# ENV NOTVISIBLE "in users profile"
# RUN echo "export VISIBLE=now" >> /etc/profile


RUN apt-get install -y firefox 
RUN apt-get install -y sudo 

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
#RUN echo 'developer:developer' | chpasswd
# CMD /usr/bin/firefox

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

