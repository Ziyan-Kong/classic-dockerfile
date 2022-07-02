# Basic linux
FROM ubuntu:20.04

# Timezone
ENV TZ=Asia/Shanghai DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
		apt-get install -y tzdata && \
		ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && \
		echo ${TZ} > /etc/timezone && \
		dpkg-reconfigure --frontend noninteractive tzdata && \
		rm -rf /var/lib/apt/lists/*

# Basic configure
RUN apt-get update && apt install -y gcc cmake libcurl4-openssl-dev libxml2-dev curl libcairo2-dev libssl-dev vim wget git g++

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
