#!/usr/bin/env bash

set -eu

# Default values
image_file="image.ext2"
dockerfile="Dockerfile"
size="1500M"

# Help message function
print_help() {
  echo "Usage: $0 [options] [<image_file>]"
  echo ""
  echo "Options:"
  echo "  --size, -s       Specify the size (default: 1500M)"
  echo "  --dockerfile, -f Specify the dockerfile (default: ./Dockerfile)"
  echo "  --output, -o     Specify the output image file (default: ./image.ext2)"
  echo "  --help, -h       Display this help message"
}

# Parse options
while getopts ":s:f:o:h-:" opt; do
  case $opt in
    s) size="$OPTARG" ;;
    f) dockerfile="$OPTARG" ;;
    o) image_file="$OPTARG" ;;
    h) print_help; exit 0 ;;
    -)
      case $OPTARG in
        size) size="${!OPTIND}"; OPTIND=$((OPTIND + 1)) ;;
        dockerfile) dockerfile="${!OPTIND}"; OPTIND=$((OPTIND + 1)) ;;
        output) image_file="${!OPTIND}"; OPTIND=$((OPTIND + 1)) ;;
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

echo "Image file: $image_file"
echo "Docker file: $dockerfile"
echo "Size: $size"

# Privileged section running in a namespace
buildah unshare bash << EOF
set -eu
img=\$(buildah bud --dns=none --quiet --layers -f ${dockerfile})

cnt=\$(buildah from \$img)
mnt=\$(buildah mount \$cnt)
cleanup() {
	buildah umount \$cnt > /dev/null
	buildah rm \$cnt > /dev/null
}
trap cleanup EXIT

rm -f ${image_file}
mkfs.ext2 -b 4096 -d \$mnt ${image_file} ${size} > /dev/null

EOF
