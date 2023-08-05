#!/usr/bin/env bash

# install
function install_docker(){
    apt install docker.io -y
}


# start docker service and enbale start on booting
# systemctl start docker.service;systemctl enable docker.service;

# check runing
function check_docker_running(){
    docker ps
    # or you can run others:
    # docker info
}

# # task:s:use replacing
# function use_repalcing(){
#     f=/etc/docker/daemon.json 
#     [ $3 ] && f="$3"
#     n=`echo "$1" | grep "$2"`
#     o=`cat $f | sed "/^#/d" | tail -1 | cut -d " " -f2`
#     replace_source "$o" "$n"
# }
# # task:e:use replacing
# function replace_source(){
#     # o=http://security.ubuntu.com/ubuntu/
#     # n=https://mirrors.tuna.tsinghua.edu.cn/ubuntu/
#     o=$1
#     n=$2

#     sed -i "s,http://archive.ubuntu.com/ubuntu/,$n,g" /etc/apt/sources.list
#     sed -i "s,http://security.ubuntu.com/ubuntu/,$n,g" /etc/apt/sources.list
#     [ $n != $o ] && sed -i "s,$o,$n,g" /etc/apt/sources.list
# }
function add_json_file(){
    f=/etc/docker/daemon.json 
    txt="{\n}"
    [ $1 ] && f="$1"
    [ $2 ] && txt="$2"
    [ ! -e "$f" ] && echo -e "$txt" > $f
}
# usage:
# add_json_file "$loc" "$txt"


function def_json_str(){
    s="\""
    [ $2 ] && s=$2
    echo "${s}$1${s}"
}
# usage:
# def_json_str "host" "\""
# def_json_str "host" "'"

function def_json_kv(){
    echo "\"$1\":$2,"
}
# usage:
# def_json_kv  "hosts" "[]" # arr
# def_json_kv  "hosts" "0" # num
# def_json_kv  "hosts" "\"0\"" # str
# def_json_kv  "hosts" "True" # boolean




function daemon_enable_remote_api(){
f=/etc/docker/daemon.json
# # # add_json_file "$f"
# key="insecure-registries"
# kv=`cat $f | grep $key`
# echo "kv:$kv"
# val=`echo "$kv"| sed -E "s#\"$key\": *##g"`
# echo "val:$val"
# echo "key:$key"
# nval="[\"127.0.0.1\"],"
# nkv=`echo "$kv" | sed  "s#$val#$nval#g"`
# # echo "$nkv"
# # echo "$kv"| sed -E "s#$val#$nval#g"

txt=`cat $f`
key="hosts"
# kv=`echo "$txt" | grep $key`
# val=`echo "$kv" | sed -E "s#\"$key\": *##g"`
# echo "val:$val"
# echo "key:$key"
# echo "kv:$kv"

# hosts='["tcp://0.0.0.0:2375","unix:///var/run/docker.sock"]'
hosts='["tcp://127.0.0.1:2375","unix:///var/run/docker.sock"]'

kv=`def_json_kv  "hosts" "$hosts"`
# sed  "s#^{#{\n    $kv#" $f

echo "$txt"| grep "\"$key\":" > /dev/null 2>&1 ; if [ $? -eq 0 ] ; then sed -i "s#\"$key\":.*#$kv#" $f ; else sed -i "s#^{#{\n    $kv#"  $f ; fi
cat $f | grep $key


f=/usr/lib/systemd/system/docker.service
# cat $f | grep ExecStart=
bk="ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock"
n="ExecStart=/usr/bin/dockerd";
o="ExecStart=.*";
# sed -E "s,ExecStart=.*,$n,g" $f | grep ExecStart=;

sed -iE "s,ExecStart=.*,$n,g" $f
cat $f | grep ExecStart=;

# del o
# o="-H fd://";sed -E "s,$o,,g" $f | grep ExecStart= 
# o="-H fd://";sed -iE "s,$o,,g" $f

}

function reset_config(){
    f=/etc/docker/daemon.json
    cat > $f <<EOF
{
    "insecure-registries": ["127.0.0.1","harbor.domain.io"],
    "registry-mirrors": ["https://registry.cn-hangzhou.aliyuncs.com"],
    "log-driver":"json-file",
    "log-opts":{
        "max-size" :"50m","max-file":"3"
    }
}
EOF
    cat $f
}
# "hosts": ["tcp://0.0.0.0:2375","unix:///var/run/docker.sock"],




# speed up docker in china (docker registry-mirrors setting)
# ...

# docker repository configuration insecure-registries
# ...

function reload_confg(){
    # restart daemon-reload and docker
    systemctl daemon-reload ;systemctl restart docker;
}



# uninstall
function uninstall_docker(){
    apt remove docker.io -y 
    rm -rf /var/lib/docker
    rm -rf /var/lib/containerd
    rm -rf /etc/docker/daemon.json
}


# let docker client in window access docker server in wsl
# ...

# let docker client in wsl access docker server in window (docker desktop)
# ...


# install_docker
# uninstall_docker

case "$1" in
    install|i|add|1)
        install_docker ;exit 0;
    ;;
    remove|uninstall|del|2)
        uninstall_docker ;exit 0;
    ;;
    checkrunning|check|crn)
        check_docker_running ;exit 0;
    ;;
    cnf)
        cat /etc/docker/daemon.json ;exit 0;
    ;;
    reload-cnf)
        reload_confg ;exit 0;
    ;;
    editjson|reset-cnf)
        reset_config ;reload_confg;exit 0;
    ;;
    enable-remote-api)
        daemon_enable_remote_api ;reload_confg;exit 0;
    ;;
esac


# cd /mnt/d/code/shell
# wslubt-docker/index.sh
# wslubt-docker/index.sh enable-remote-api

# tof="wslubt-docker/index.sh";


# docker context --help
# docker context ls
# docker context create wsl --docker "host=tcp://127.0.0.1:2375"
# docker context use wsl
# docker context rm wsl

