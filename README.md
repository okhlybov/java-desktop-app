# Java desktop application: from zero to hero

This is a Java project representing complete build pipeline from ***source code*** all the way to ***platform-specific installer***.

It is intended to be a starting point for a custom project which can be derived through gradual refactoring.

## Features

* Portable [Gradle](https://gradle.org/) project
* Multi-module Java application split into a backend and a set of frontends
* Command-line application frontend
* [JavaFX](https://openjfx.io/) graphic application frontend
* Single file self-contained ***Linux*** application built with [AppImage](https://appimage.org/)
* Full-fledged self-contained ***Windows*** installer built with [Inno Setup](https://jrsoftware.org/isinfo.php)

## Prerequisites

* Java 17+ runtime
* Inno Setup compiler (_Windows_)

The above Java runtime should be capable of just running the Gradle wrapper; the rest of the toolchain (including platform-specific parts) will be downloaded and configured automagically. If no Java runtime is installed, an [Adoptium Temurin](https://adoptium.net/temurin/releases/?version=17) runtime is a solid choice.

Note that Inno Setup compiler so far can not be obtained automagically and thus should be downloaded and installed [manually](https://jrsoftware.org/isdl.php) or through WinGet

```shell
winget install --id JRSoftware.InnoSetup -e -s winget -i
```

## Kickstart

### Obtain this project's source

```shell
git clone https://github.com/okhlybov/java-desktop-app
```

### Get into the source directory and execute

(_Linux_)

```shell
sh gradlew clean release
```

(_Windows_)

```shell
gradlew.bat clean release
```

### Grab system-specific installer

The build artifacts are placed into the `runtime/build/release` directory.