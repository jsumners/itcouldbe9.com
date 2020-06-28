# itcoulbe9.com

[Ansible](https://github.com/ansible/ansible) playbook for configuring whatever
server will be managing itcoulbe9.com.

## Setup

1. Install Ansible: `pip install --user git+https://github.com/ansible/ansible.git@v2.9.10`
1. Add vault password to `.vault-pass`
1. Install `sshpass`: `sudo port install sshpass`

## Server Prep

Some things need to be done on the server manually before it is ready to
accept Ansible automation.

1. Update `/etc/ssh/sshd_config` to enable "PasswordAuthentication yes"
1. `ln -s /etc/sv/sshd /var/service`
1. Make sure non-root user is added: `useradd -m jsumners && passwd jsumners`
1. `xbps-install -y python3`
1. Add baseline `/etc/rc.local`:
    ```
    ip addr add 45.63.16.142/8 brd 45.255.255.255 scope global dev eth0
    ip addr add 2001:19f0:5:23de:5400:00ff:fe1e:54e2/64 scope global dev eth0
    ip link set up dev eth0
    ip route add default via 45.63.16.1 dev eth0
    ```
1. `sv stop dhcpcd && rm /var/service/dhcpcd && /etc/rc.local`
1. Update `/etc/resolv.conf`:
    ```
    nameserver 108.61.10.10
    nameserver 8.8.8.8
    ```

Finally, run `ansible-playbook -l production main.yml`.

## Post Setup

1. Run `acmetool quickstart` to bootstap the tool. Choose "stateless" challenges.
1. `acmetool want jrfom.com james.roomfullofmirrors.com sumners.info itcouldbe9.com haplo-music.com`
1. `sv restart haproxy`
