# IcoMoonGen

A command-line tool that generates type-safe code from IcoMoon font.

## ToDo

- [ ] Support templates file

## Installation
### Homebrew
```shell
$ brew install tosaka07/tap/icomoongen
```
### Mint
```shell
$ mint install tosaka07/IcoMoonGen
```
### Manual
```shell
$ git clone https://github.com/tosaka07/IcoMoonGen.git
$ make install
```

## Usage

Run icomoongen help to see usage instructions.

```
USAGE: icomoongen generate <input> [--spec <spec>] [--verbose]

ARGUMENTS:
  <input>

OPTIONS:
  -s, --spec <spec>        (default: icomoongen.yml)
  -v, --verbose
  --version               Show the version.
  -h, --help              Show help information.
```

### icomoongen.yml

You can specify a spec with yml.

```
code:
  - templateName: swift
    output: output.swift
font:
  - type: ttf
    output: some.ttf
```

## Development

**open project with Xcode**

```sh
$ make generate
$ open IcomoonGen.xcodeproj
```

**Local build**

```
$ make build-debug
$ ./build/debug/icomoongen ...
```

**Release build**

```sh
$ make build
```

## License

MIT
