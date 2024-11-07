FROM i386/alpine:3.17
# Install required packages
RUN apk update && apk add alpine-base udev-init-scripts udev-init-scripts-openrc eudev xorg-server xf86-input-libinput lightdm i3wm font-dejavu xrandr xev
# Setup the init script
RUN rc-update add bootmisc boot && rc-update add udev sysinit && rc-update add udev-trigger sysinit && rc-update add udev-settle sysinit && rc-update add udev-postmount default && rc-update add dbus default && rc-update add lightdm default
# Add a user
RUN adduser -D -s /bin/ash user && echo 'user:password' | chpasswd
# Configure lightdm to start i3
RUN sed -i "s/#autologin-user=/autologin-user=user/g" /etc/lightdm/lightdm.conf && sed -i "s/#autologin-user-timeout=0/autologin-user-timeout=0/g" /etc/lightdm/lightdm.conf && sed -i "s/#autologin-session=/autologin-session=i3/g" /etc/lightdm/lightdm.conf
# Add a script to support display autoresizing
COPY --chown=user:user ./scripts/99-screen-resize.sh /etc/X11/xinit/xinitrc.d/99-screen-resize.sh
# Temporary hacks for input detection
COPY --chown=root:root ./sys_hack /sys
COPY --chown=root:root ./run_hack /run

# useful apps
RUN apk add i3status xpdf rofi gvim okular xterm pcmanfm feh

# assets
COPY --chown=user:user ./data /home/user/data
# i3 config
COPY --chown=user:user ./config /home/user/.config

CMD [ "/bin/sh" ]
