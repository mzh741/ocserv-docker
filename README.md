```
wget -qO- https://get.docker.com/ | sh
cd ~ && git clone https://github.com/mzh741/ocserv-docker.git
cd ~/ocserv-docker && docker build --no-cache -t ocserv-docker .
docker run -d --privileged --name ocserv-docker -v ~/ocserv-docker/ocserv:/etc/ocserv -p 999:999/tcp ocserv-docker
docker logs ocserv-docker
```

Win, Mac, Linux [Link1](https://www.haskins.yale.edu/docdepot/published/WG/show.php?q=SEFTSzAx-58c63f59), [iOS](https://itunes.apple.com/us/app/cisco-anyconnect/id392790924?mt=8), [Android](https://play.google.com/store/apps/details?id=com.cisco.anyconnect.vpn.android.avf&hl=en)

## 自定义证书, 密钥
因为是构建一个独立的 box 进行分发, 方便快速部署一个 ocserv, 所以将证书, 密钥, 用户都集成在里面了, 此刻方便使用. 如果对于有担心的, 可以 `docker run -t -i wppurking/ocserv bash` 进入到 box 中使用 `certtool` 重新进行处理, 具体操作步骤参考 [[原创]linode vps debian7.5安装配置ocserv(OpenConnect server)](http://luoqkk.com/linode-vps-debian-installation-and-configuration-ocserv-openconnect-server.html)

证书是在 Docker Build 的过程中自动生成的, 其生成的目的地为 `/opt/certs`
[成功更换 certs 的例子](https://twitter.com/douglas_lee/status/590245251257737216)

TODO: 自签名客户端证书登陆

## 用户名
为了使新手能够最快的使用上 AnyConnect (也方便我自己同一设备能方便的链接多个不同地域的 VPS) 我预先设置了两个初始化的账号密码, 但同时将用于提供账号密码的 `ocserv/ocpasswd` 文件放在 Box 外面, 运行 Container 时使用 Volume 挂在进去, 这样方便熟悉 Docker 的用户能够方便的 使用 `ocpasswd` 命令修改或者重新生成自己的用户密码.

提供一个非常简单的更换密码操作, 复制命令就好了(建立在按照上面的操作基础上哈):
### 新添加用户
```
$> docker exec -it $(docker ps -a | grep vpn_run | awk '{print $1}') ocpasswd yourname
$> Enter password:
$> Re-enter password:
```
这个的原理是借用 docker 运行中的 container , 在其里面运行 `ocpasswd` 改变 Volumn 进去的 `./ocserv/ocpasswd` 文件内容, 所以当你运行完这行命令, 本机(非 container 中)的 `./ocserv/ocpasswd` 的文件内容会真实发生变化

### 清理掉预设的两个用户名
直接打开 `./ocserv/ocpasswd` 删掉 wyatt/holly 开头的两行就好了. 


## 信息
* Box Size: 164 MB   (原来是 380+ MB, 基础镜像缩减)
* 基础 Box: ubuntu:trusty
* 测试过的环境: 
  * [Linode 1G Ubuntu 14.04 LTS]
  * [Vultr 768MB Ubuntu 14.04 LTS]
  * [DigitalOcean 512MB Docker 1.2.0 on Ubuntu 14.04]

## Refs
* [ocserv 0.8.2 Manual](http://www.infradead.org/ocserv/manual.html)
* [[原创]linode vps debian7.5安装配置ocserv(OpenConnect server)](http://luoqkk.com/linode-vps-debian-installation-and-configuration-ocserv-openconnect-server.html)
* [Install Cisco AnyConnect Server on a Generic Linux Server](https://izhaom.in/2014/08/install-cisco-anyconnect-server-on-a-generic-linux-server/)
* [AnyConnect 带来 iPhone 上的新生活](http://imkevin.me/post/80157872840/anyconnect-iphone)
* [Install Ocserv on CentOS 6.5](https://botu.me/install-ocserv-on-centos6/)
* [Gnutls 3.1.23 on Ubuntu 14.04](http://www.bauer-power.net/2014/06/how-to-install-gnutls-3123-from-source.html)
