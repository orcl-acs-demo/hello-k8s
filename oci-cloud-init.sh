# https://github.com/oracle/ol-sample-scripts/blob/master/oci-provision/oci-cloud-init.sh

readonly PGM=$(basename $0)
readonly YUM_OPTS="-d1 -y"
readonly USER="opc"
readonly USER_HOME=$(eval echo ~${USER})
readonly VNC_PASSWORD="MySecretVNCPassword"


install_fluxbox() {
  header "Install Fluxbox"
  yum install ${YUM_OPTS} fluxbox xterm xmessage xorg-x11-fonts-misc
  yum install ${YUM_OPTS} tigervnc-server

  su - ${USER} -c "\
    mkdir .vnc; \
    echo \"${VNC_PASSWORD}\" |  vncpasswd -f > .vnc/passwd; \
    chmod 0600 .vnc/passwd; \
    vncserver; \
    sleep 5;
    vncserver -kill :1; \
    sed -i -e 's!/etc/X11/xinit/xinitrc!/usr/bin/fluxbox!' .vnc/xstartup; \
    "
}

install_packs(){
yum -y update; \
yum -y install yum-utils && \
yum-config-manager --enable rhel-7-server-optional-rpms && \
yum-config-manager --enable ol7_addons ol7_latest && \
yum -y install compat-libstdc++-33 \
yum -y install binutils && \
yum -y install compat-libcap1 && \
yum -y install compat-libstdc++-33.x86_64 && \
yum -y install compat-libstdc++-33.i686 && \
yum -y install gcc && \
yum -y install gcc-c++ && \
yum -y install glibc.x86_64 && \
yum -y install glibc.i686 && \
yum -y install glibc-devel.x86_64 && \
yum -y install libaio.x86_64 && \
yum -y install libaio-devel.x86_64 && \
yum -y install libgcc.x86_64 && \
yum -y install libgcc.i686 && \
yum -y install libstdc++.x86_64 && \
yum -y install libstdc++.i686 && \
yum -y install libstdc++-devel.x86_64 && \
yum -y install dejavu-serif-fonts && \
yum -y install ksh && \
yum -y install make && \
yum -y install sysstat && \
yum -y install numactl.x86_64 && \
yum -y install numactl-devel.x86_64 && \
yum -y install motif.x86_64 && \
yum -y install motif-devel.x86_64 && \
yum -y install redhat-lsb.x86_64 && \
yum -y install redhat-lsb-core.x86_64 && \
yum -y install openssl \
yum install -y yum-utils ; \
yum install -y jq; \
yum install -y telnet; \
yum install -y sos; \
yum install -y NetworkManager; \
yum install -y git; \
yum install -y unzip; \
yum clean all;

}

install Server_with_GUI() {
# yum groupupdate "Development Libraries"
# yum groupremove "Development Libraries"
yum groupinstall -y "Development tools"; \
yum groupinstall -y "Server with GUI"
}

install_docker() {
  echo "Install Docker"
  yum -y erase docker-engine docker-engine-selinux ; \
  yum -y install docker-engine curl-devel

  yum install ${YUM_OPTS} docker-engine

  # Add User to docker group
  usermod -a -G docker ${USER}

  # Enable and start Docker
  systemctl enable docker
  systemctl start docker

  su - ${USER} -c "pip3 install --user docker-compose"
}


main() {
  #install_python3
  #install_fluxbox
  #install_docker      # docker-compose depends on python3
  #configure_firewall
  timedatectl set-timezone Europe/Warsaw
  install_packs
}

main "$@"
