#!/usr/bin/env bash

set -eu

# Default values
image_file="image.ext2"
size="1500M"

# Help message function
print_help() {
  echo "Usage: $0 [options] [<image_file>]"
  echo ""
  echo "Options:"
  echo "  --size, -s      Specify the size (default: 1500M)"
  echo "  --help, -h      Display this help message"
  echo ""
  echo "Positional Arguments:"
  echo "  <image_file>    Path of the image file (default: ./image.ext2)"
}

# Parse options
while getopts ":s:h-:" opt; do
  case $opt in
    s) size="$OPTARG" ;;
    h) print_help; exit 0 ;;
    -)
      case $OPTARG in
        size) size="${!OPTIND}"; OPTIND=$((OPTIND + 1)) ;;
        help) print_help; exit 0 ;;
        *)
          echo "Invalid option: --$OPTARG" >&2
          exit 1
          ;;
      esac
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

# Positional argument
if [ $# -gt 0 ]; then
  image_file="$1"
fi

echo "Image file: $image_file"
echo "Size: $size"

# Privileged section running in a namespace
buildah unshare bash << EOF

buildah bud --layers -t alpine_root -f Dockerfile

alpine_root_cnt=\$(buildah from alpine_root)
mnt=\$(buildah mount \$alpine_root_cnt)
cleanup() {
	buildah umount \$alpine_root_cnt
	buildah rm \$alpine_root_cnt
}
trap cleanup EXIT

rm -f ${image_file}
mkfs.ext2 -b 4096 -d \$mnt ${image_file} ${size}

EOF
