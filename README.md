# Java desktop application: from zero to hero

This is a Java project representing complete build workflow from ***source code*** all the way to ***platform-specific installer***.

It is intended to be a starting point for a custom project which can be derived through gradual refactoring.

## Features

* Portable [Gradle](https://gradle.org/) project
* Multi-module Java application split into a backend and a set of frontends
* Command-line application frontend
* [JavaFX](https://openjfx.io/) graphic application frontend
* Single file self-contained ***Linux*** application built with [AppImage](https://appimage.org/)
* Full-fledged self-contained ***Windows*** installer built with [Inno Setup](https://jrsoftware.org/isinfo.php)

## Prerequisites

* Java 17+ JDK

The above Java development kit should be capable of just running the Gradle wrapper; the rest of the toolchain
(including platform-specific parts) will be downloaded and configured automagically.
If no Java runtime is installed, an [Adoptium Temurin](https://adoptium.net/temurin/releases/?version=17)
runtime is a solid choice.

Provided build scripts locate and use locally installed AppImage and Inno Setup tools and make an attempt to
download and install them if not found.

The Inno Setup compiler can also be installed [manually](https://jrsoftware.org/isdl.php) or through WinGet

```shell
winget install --id JRSoftware.InnoSetup -e -s winget -i
```

## Kickstart

### Obtain this project's source

```shell
git clone https://github.com/okhlybov/java-desktop-app
```

### Get into the source directory and execute

__Linux__

```shell
sh gradlew clean release
```

__Windows__

```shell
gradlew.bat clean release
```

### Grab system-specific installer

The build artifacts are placed into the `runtime/build/release` directory.

## WSL2 host

Issue the following command to (likely) solve permissions problems in the Linux container should they arise

```shell
echo -e '\n[automount]\nenabled = true\noptions = "metadata,umask=22,fmask=11"'  | sudo tee -a /etc/wsl.conf > /dev/null
```

After that, shutdown the WSL subsystem

```cmd
wsl --shutdown
```

__Arch Linux__

```shell
pacman -Syu jdk-openjdk binutils sudo fuse2
```

__Debian Linux__

```shell
sudo apt-get install default-jdk binutils curl file fuse libfuse2
```

__?Ubuntu Linux?__

```shell
sudo apt-get install default-jdk binutils curl libfuse2t64
```
