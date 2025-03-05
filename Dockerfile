FROM docker.io/i386/alpine:3.17
# Install required packages

RUN echo -e "\n@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
# Default DNS server
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf
RUN apk update && apk add alpine-base udev-init-scripts udev-init-scripts-openrc eudev xorg-server xf86-input-libinput lightdm i3wm font-dejavu xrandr xev bash
# Setup the init script
RUN rc-update add bootmisc boot && rc-update add udev sysinit && rc-update add udev-trigger sysinit && rc-update add udev-settle sysinit && rc-update add udev-postmount default && rc-update add dbus default && rc-update add lightdm default
# Add a user
RUN adduser -D -s /bin/bash user && echo 'user:password' | chpasswd
# Allow root login
RUN echo 'root:password' | chpasswd
# Configure lightdm to start i3
RUN sed -i "s/#autologin-user=/autologin-user=user/g" /etc/lightdm/lightdm.conf && sed -i "s/#autologin-user-timeout=0/autologin-user-timeout=0/g" /etc/lightdm/lightdm.conf && sed -i "s/#autologin-session=/autologin-session=i3/g" /etc/lightdm/lightdm.conf
# Add a script to support display autoresizing
COPY --chown=user:user ./scripts/99-screen-resize.sh /etc/X11/xinit/xinitrc.d/99-screen-resize.sh

# terminal apps
RUN apk add vim python3 nodejs gcc nano openssh
# gui apps
RUN apk add xpdf rofi gvim gedit xterm pcmanfm feh polybar thunar sgt-puzzles@testing

# the sgt-puzzles package has broken desktop files...
RUN sed -i 's/Exec=sgt-/Exec=/' /usr/share/applications/sgt-*.desktop

# config folder
COPY --chown=user:user ./config /home/user/.config
# xpdf config goes directly in the home dir
RUN mv /home/user/.config/.xpdfrc /home/user/

CMD [ "/bin/sh" ]
