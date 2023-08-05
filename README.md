# wslubt-use-docker

docker on window & wsl & ubuntu


## usage
```bash
# only download index.sh file
curl -O https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/wslubt-use-docker/main/index.sh

# get script usage
# ./index.sh -h

# get script version
# ./index.sh -v

# zero:task:s:swicth-user
# if you do not have the rights to edit file /etc/apt/sources.list
# you can swicth user with su.
# su [options] [-] [<user> [<argument>...]]
# su - $USER
# zero:task:e:swicth-user

./index.sh install
```


you can use as below ( including download , add-x-right , run-sh, and del-sh) :
```bash
# download -> add-x-right -> run-sh
todir=./tool/wslubt-use-docker; 
tof="$todir/index.sh";
gcproxy="https://ghproxy.com/";
uri="${gcproxy}https://raw.githubusercontent.com/ymc-github/wslubt-use-docker/main/index.sh";  
mkdir -p "$todir"; curl -o "$tof" -s $uri; chmod +x "$tof";

# install docker
"$tof" install

# reset daemon config
"$tof" reset-cnf

# set docker remote api
"$tof" enable-remote-api

# get current daemon config
"$tof" cnf

# reload cnf
"$tof" reload-cnf

# remove docker
"$tof" remove


# del-sh:
# rm -rf "$todir";
```


### let docker client on window access docker server on wsl
- docker server enbale remote api
```bash
"$tof"  enable-remote-api
```

- docker client use relative context
```powershell
# docker context --help
# docker context ls
docker context create wsl --docker "host=tcp://127.0.0.1:2375"
docker context use wsl
# docker context rm wsl
```


## Author

name|email|desciption
:--|:--|:--
yemiancheng|<ymc.github@gmail.com>||

## License
MIT
