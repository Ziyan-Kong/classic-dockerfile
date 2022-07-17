# Basic linux
FROM ubuntu:20.04

# ENVs
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV R_BASE_VERSION 4.2.0

# Labels
LABEL maintainer "Pengfei Liu pfliu@aptbiotech.com"

# Timezone
ENV TZ=Asia/Shanghai DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
		apt-get install -y tzdata && \
		ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && \
		echo ${TZ} > /etc/timezone && \
		dpkg-reconfigure --frontend noninteractive tzdata && \
		rm -rf /var/lib/apt/lists/*

# Basic configure
RUN apt-get update && \
	apt-get install -yq gcc cmake libcurl4-openssl-dev libxml2 libxml2-dev curl && \
	apt-get install -yq libcairo2-dev libssl-dev vim wget git g++ && \
	apt-get install -yq apt-utils software-properties-common && \
	apt-get install -yq locales unzip dos2unix sudo build-essential && \
	apt-get install -yq zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev && \
	apt-get install -yq libreadline-dev libffi-dev && \
	rm -rf /var/lib/apt/lists/*

# Install R 4.2.0
RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common dirmngr
#RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
#RUN gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN apt-get update && apt-get install -y --no-install-recommends r-base r-base-dev




# Install rJava
RUN apt-get update && \
		add-apt-repository -r ppa:marutter/rrutter3.5 && \
		add-apt-repository ppa:c2d4u.team/c2d4u4.0+ && \
		apt-get install r-cran-rjava

# Install packages
RUN Rscript -e 'install.packages(c("ggplot2", "ggprism", "openxlsx", "ggpubr", "stringr", "stringi"), repos="http://mirrors.tuna.tsinghua.edu.cn/CRAN")'


# Install python
RUN wget https://www.python.org/ftp/python/3.10.5/Python-3.10.5.tgz
RUN tar -zxf Python-3.10.5.tgz
WORKDIR /Python-3.10.5
RUN ./configure
RUN make altinstall
RUN make install
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py
RUN pip3 install --upgrade pip
RUN pip3 install setuptools
