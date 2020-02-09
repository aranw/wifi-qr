# wifi-qr

wifi-qr attempts to simplify the process of sharing passwords with mobiles by generating a wifi qr code where mobile uses can scan to connect to the wifi network.

Currently this script only supports macOS.

Inspired by [wifi-password](https://github.com/rauchg/wifi-password)

## How to use

**1. Install it**

With `curl`:

```
curl -L https://raw.github.com/aranw/wifi-qr/master/wifi-qr.sh -o ~/bin/wifi-qr && chmod +x ~/bin/wifi-qr
```

If you don't have `~/bin` in your `$PATH`, replace it with `/usr/local/bin` or
similar.

**2. Use it:**

To get the password for the WiFi you're currently logged onto:

```
$ wifi-qr
```

To get it for a specific SSID:

```
$ wifi-qr <ssid>
```

## License

MIT
