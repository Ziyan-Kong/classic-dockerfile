FROM rocker/shiny:latest

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
		apt-get install -y gnupg gcc g++ cmake libcurl4-openssl-dev curl libcairo2-dev libssl-dev vim wget git libxml2-dev liblzma-dev libbz2-dev

# R packages
RUN Rscript -e 'install.packages(c("ggplot2", "ggprism", "stringr", "reshape2", "openxlsx"), repos = "http://mirrors.tuna.tsinghua.edu.cn/CRAN")'
