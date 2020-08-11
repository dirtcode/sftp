# info from:
# https://docs.docker.com/engine/examples/running_ssh_service/

FROM ubuntu:20.04

RUN apt-get update && apt-get install -y openssh-server nano
RUN mkdir /var/run/sshd
RUN echo 'root:' | chpasswd

COPY sshd_config_extra /root/sshd_config_extra
RUN cat /root/sshd_config_extra >> /etc/ssh/sshd_config

#RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
#RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
#RUN echo 'Match User root' >> /etc/ssh/sshd_config
#RUN echo 'ChrootDirectory /data/%u' >> /etc/ssh/sshd_config
#RUN echo 'ForceCommand internal-sftp' >> /etc/ssh/sshd_config
#RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
