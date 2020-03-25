# Sheep Live

Sheep Live is a live Linux distribution used as a runtime environment for Sheep.

## Why a distribution for Sheep

Sheep could be run from any Linux distribution as soon as all the dependencies are present.

Providing a specific distribution gives two major advantages to avoid undesirable side effects

1. A Linux environment to run Sheep with all the needed material for Sheep inside. It avoid internet interaction during the Sheep process
2. A distribution used to test and validate sheep int the continus integration platform

## Building sheep-live

Sheep Live is a Debian 10 Linux based on the [GRML Live](https://github.com/grml/grml-live) building system.

For development purpose, it can be built easily using [Vagrant](https://www.vagrantup.com/) and [Virtual Box](https://www.virtualbox.org/).

Basically run

```bash
$ vagrant up
```

When the command is done, built artifacts can be found in the `build/` folder:

* `vmlinuz` - Linux kernel
* `initrd.img` - Linux init ramdisk
* `sheep-live.squashfs` - Root filesystem

To re-run the build

```bash
$ vagrant provision
```

## Using the Sheep Live image

The purpose of Sheep Live is primarily to network boot a server.

Depending on your specificities (Legacy boot or EUFI boot and the bootloader you use) your standard process applies to network boot your server using Sheep Live.

As Sheep Live is built on top of GRML, [GRML kernel parameters](https://git.grml.org/?p=grml-live.git;a=blob_plain;f=templates/GRML/grml-cheatcodes.txt;hb=HEAD) can be used to tune your configuration.

Here are the Sheep specific kernel parameters to automatically run Sheep when Sheep Live is booted:

* `sheep.script=http://...` - URL to download Sheep script from
* `sheep.config=http://...` - URL to download the Sheep YAML configuration for your machine
* `services=sheep` - To automatically start the Sheep service on boot (automatically install linux on your drive). 

without the `services` parameter you'll have to log into Sheep Live to run the Sheep service

```
$ systemctl start sheep
```

Below a sample boot configuration compatible with `pxelinux` and `syslinux` bootloaders

```
DEFAULT sheep

label sheep
    kernel /vmlinuz
    append boot=live fetch=http://<BOOT_SERVER>/sheep-live.squashfs initrd=/initrd.img ssh=sheep sheep.script=http://<BOOT_SERVER>/sheep sheep.config=http://<BOOT_SERVER>/sheep.yml services=sheep
```
