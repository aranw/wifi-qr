# wifi-qr

<p align="center"><img src="/img/wifi-qr.gif?raw=true"/></p>

wifi-qr attempts to simplify the process of sharing passwords with mobiles by generating a wifi qr code where mobile uses can scan to connect to the wifi network.

wifi-qr depends on [qrencode](https://linux.die.net/man/1/qrencode)

Currently this script only supports macOS.

Inspired by [wifi-password](https://github.com/rauchg/wifi-password)

## How to use

### Prerequisites

With [Homebrew](https://github.com/Homebrew/homebrew):

``` shell
$ brew install qrenode
```

### Install

With `curl`:

``` shell
$ curl -L https://raw.github.com/aranw/wifi-qr/master/wifi-qr.sh -o ~/bin/wifi-qr && chmod +x ~/bin/wifi-qr
```

If you don't have `~/bin` in your `$PATH`, replace it with `/usr/local/bin` or
similar.

### Usage

To get the password for the WiFi you're currently logged onto:

``` shell
$ wifi-qr
```

To get it for a specific SSID:

``` shell
$ wifi-qr <ssid>
```

## License

MIT
