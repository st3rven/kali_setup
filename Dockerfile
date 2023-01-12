FROM kalilinux/kali-rolling

ARG DEBIAN_FRONTEND=noninteractive
# Update
RUN apt-get -y update && apt-get -y dist-upgrade && apt-get -y autoremove && apt-get clean

# Install some useful packages
RUN apt-get -y install git micro pciutils usbutils

# Install library and package
#RUN apt-get install -y libcurl4-openssl-dev
#RUN apt-get install -y libssl-dev
#RUN apt-get install -y jq
#RUN apt-get install -y ruby-full
#RUN apt-get install -y libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
#RUN apt-get install -y build-essential libssl-dev libffi-dev python3-dev
#RUN apt-get install -y python-setuptools
#RUN apt-get install -y libldns-dev
#RUN apt-get install -y python3-pip
#RUN apt-get install -y rename

# customize image
COPY setup_docker.sh /root/setup_docker.sh
RUN chmod +x /root/setup_docker.sh
RUN /root/setup_docker.sh root

ENTRYPOINT ["/bin/bash"]
