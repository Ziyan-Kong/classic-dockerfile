### 1. 构建镜像

```shell
docker build -t shiny:v1.0.0 .
```

### 2. 构建并启动容器

```shell
docker run -itd -v /home/QC/ShinyAPP:/srv/shiny-server -v /home/QC/ShinyLog:/var/log/shiny-server -p 3838:3838 shiny:v1.0.0
```

### 3. 启动 shiny

```shell
# ui.R
# server.R
```

- 将上述两个文件传到`/home/QC/ShinyAPP`路径下，shiny-server自动执行相关文件

### 4. web启动会话

```shell
http://ip:3838
```

