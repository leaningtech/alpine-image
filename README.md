# Custom Alpine Image for virtual machines

This repository provides a simple and efficient way to build an Alpine-based virtual machine image.

## Building the Image

Use the `build.sh` script to generate the image:

```sh
./build.sh
```

Options:
- `-s, --size <size>`: Specify the image size (default: 1500M).
- `-f, --dockerfile <path>`: Specify a custom Dockerfile (default: `./Dockerfile`).
- `-o, --output <file>`: Specify the output image file (default: `image.ext2`).

For additional details on creating and customizing ext2 images for use with CheerpX, refer to the [custom disk images](https://cheerpx.io/docs/guides/custom-images) guide in the CheerpX documentation.

## License

This project is released under the Apache License, Version 2.0.

You are welcome to use, modify, and redistribute the contents of this repository.

The public CheerpX deployment is provided **as-is** and is **free to use** for technological exploration, testing and use by individuals. Any other use by organizations, including non-profit, academia and the public sector, requires a license. Downloading a CheerpX build for the purpose of hosting it elsewhere is not permitted without a commercial license.

Read more about [CheerpX licensing](https://cheerpx.io/docs/licensing).

If you want to build a product on top of CheerpX/WebVM, please get in touch: sales@leaningtech.com