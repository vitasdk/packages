#!/bin/bash

sudo apt-get install sshpass bsdtar xutils-dev
mkdir -p ~/.ssh/
touch ~/.ssh/known_hosts
echo "|1|K7QZQZJexBCVdpiZ9eTIRbn7ZyA=|uP3PBfEWXFeesWyVtr8kdAbYGsM= ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDe/4u7lBdfESLXtU1abKORjOUHRql1sjNeUQHqAfOCUsuxR6LFhOP3vuOe1/473xr8u6JOj8E8XtA4nREv6jXhscV/Q/+/VeLKTWWYw+CQNt+Lz4/WSzq9lb5NQK0aMDds1VD6x2h26SVtSGehz9niwIhEDMvtvOzxRBmZhCqj2gE+OIJ3FGUmxIWuAncA8B6ZfMAjqcv30s5fzZwUacjr5WXnEmdo4C/vsTSpJUPaSpt1qGkrqHeWCJfnM27XWTFQVx/ZMk+bFycptNGVhHOf5Yqtj4e/FdVeHBvmJTFsHLgdp+YZiWkK7WsWeVmjcBR1kOAefdafi513sCxmdXeF" >> ~/.ssh/known_hosts
echo "|1|XV846KwSDydQe2vdRFgX4bci360=|G5NzDWkFsXhXo3Koq8j+1vOl8WA= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBF22ib7zM5u9ApfbW/xUg8unpnr1LuTTCvPf4MdmLFhEmqxrSrnt0Q7x/wN/Vo3w/RxjmiK/ukjGSWulp/PWBKE=" >> ~/.ssh/known_hosts
echo "|1|TFiAy+cxsZWXgU3EDeOtikdtDbY=|EyVMn+ixhtL8cq3ZrZWYGbe/vO8= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWdwNPZ309h8vxSAk8Ruq5VkpZdWauQqjYW5KAepqnm" >> ~/.ssh/known_hosts
pushd ..
git clone https://github.com/vitasdk/vdpm.git
cd vdpm
bash bootstrap-vitasdk.sh
popd

pushd ..
git clone https://github.com/vitasdk/vita-makepkg.git
cd vita-makepkg
cp makepkg.conf.sample makepkg.conf
popd

export VITASDK=/usr/local/vitasdk
export PATH=$(pwd)/../vita-makepkg:$VITASDK/bin:$PATH
