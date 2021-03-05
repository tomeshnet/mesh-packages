# Toronto Mesh DB build script and repository

## Repository

Deb packages availables [here](https://repo.tomesh.net/repos/apt/debian/pool/main/)

## Package Builder

The `build-all.sh` script will run `./build.sh` in each of the folders locaged under the `pacakges` tree. Each folder represents an individual deb package that will be built. The script will set the `ARCH` variable to one of `i386` `amd64` `armhf` `arm64` `all` in turn and run `./build.sh` each times.

The foldesr should be named as the package they represent. For example for the debian package `foo` the folder would be `/packages/foo/`

After execution is complete the `./build.sh` should place the coresponding `.deb` package in `/packages` that will be added to the repository. The deb package should be called `name-version-ARCH.deb`

## Using Repo

Import gpg key
```
wget -q -O - https://raw.githubusercontent.com/tomeshnet/mesh-packages/master/gpg.pub | apt-key add -
```

Add repo by creating a file `/etc/apt/sources.list.d/tomesh.list`
```
deb https://repo.tomesh.net/repos/apt/debian/ stretch main
```
