# https://github.com/oracle/ol-sample-scripts/blob/master/oci-provision/oci-cloud-init.sh

readonly PGM=$(basename $0)
readonly YUM_OPTS="-d1 -y"
readonly USER="opc"
readonly USER_HOME=$(eval echo ~${USER})
readonly VNC_PASSWORD="MySecretVNCPassword"


install_fluxbox() {
  echo_header "Install Fluxbox"
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

install_docker() {
  echo_header "Install Docker"
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
  install_docker      # docker-compose depends on python3
  #configure_firewall
}

main "$@"
