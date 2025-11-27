buildah build -f Dockerfile --dns=none --platform linux/i386 -t cheerpximage
podman create --name cheerpxcontainer cheerpximage
podman unshare bash -c '
  rootfs=$(podman mount cheerpxcontainer)
  mkfs.ext2 -b 4096 -d "$rootfs" alpine.ext2 600M
  podman umount cheerpxcontainer
'
podman rm cheerpxcontainer
buildah rmi cheerpximage
