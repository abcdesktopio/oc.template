# oc.template

## template docker files

abcdesktop template file to build application containers images from oc.apps.

Template images are used `FROM` for `Dockerfile`

If you use abcdesktop `3.0` release use `--branch 3.0`


## to clone 3.0 template 

```bash
git clone --branch 3.0 --recurse-submodules https://github.com/abcdesktopio/oc.template.git
```

## to clone 1.0 template 

```bash
git clone --recurse-submodules https://github.com/abcdesktopio/oc.template.git 
```


## to make template container image for 3.0

```bash
cd oc.template
make
```

`Makefile` build all source template images. 
The default `TAG` is `dev`


```bash
docker images
REPOSITORY                                              TAG           IMAGE ID       CREATED             SIZE
abcdesktopio/oc.template.alpine.wine                    dev           1137689ad53a   2 minutes ago       321MB
abcdesktopio/oc.template.ubuntu.wine.mswindows          dev           1dc075fc08a6   3 minutes ago       2.87GB
abcdesktopio/oc.template.ubuntu.wine                    dev           820a70e739af   6 minutes ago       2.44GB
abcdesktopio/oc.template.alpine.libreoffice             dev           360f3f577303   20 minutes ago      750MB
abcdesktopio/oc.template.ubuntu.gtk.language-pack-all   dev           ffa088de7432   21 minutes ago      1.37GB
abcdesktopio/oc.template.ubuntu.gtk.18.04               dev           6096b4d7e810   29 minutes ago      844MB
abcdesktopio/oc.template.alpine.gtk                     dev           c5c5fdb65bb3   32 minutes ago      473MB
abcdesktopio/oc.template.debian.gtk                     dev           4ac6d8a0a29a   33 minutes ago      935MB
abcdesktopio/oc.template.ubuntu.gtk.20.04               dev           05d340132498   35 minutes ago      948MB
abcdesktopio/oc.template.ubuntu.gtk                     dev           05d340132498   35 minutes ago      948MB
abcdesktopio/oc.template.debian                         dev           8e8e0f18939a   39 minutes ago      313MB
abcdesktopio/oc.template.ubuntu.22.04                   dev           40acf4266e5d   39 minutes ago      349MB
abcdesktopio/oc.template.ubuntu.20.04                   dev           b994df5df495   39 minutes ago      340MB
abcdesktopio/oc.template.ubuntu.18.04                   dev           54e37c5fc10a   40 minutes ago      289MB
abcdesktopio/oc.template.alpine                         dev           0862f2869cd9   47 minutes ago      177MB
abcdesktopio/oc.template.debian.minimal                 dev           37574f02a006   47 minutes ago      268MB
abcdesktopio/oc.template.ubuntu.minimal.22.04           dev           91a4e2a466b8   49 minutes ago      335MB
abcdesktopio/oc.template.ubuntu.minimal.20.04           dev           1e5d58f8e739   50 minutes ago      332MB
abcdesktopio/oc.template.ubuntu.minimal.18.04           dev           84f228f79697   52 minutes ago      245MB
abcdesktopio/oc.template.alpine.minimal                 dev           8528ff0674c7   54 minutes ago      92.8MB
```

To change TAG value 
```
TAG=3.0 make
```

```bash
docker images
abcdesktopio/oc.template.ubuntu.gtk.java                3.0           a76d6ef687b5   38 minutes ago      1.15GB
abcdesktopio/oc.template.alpine.libreoffice             3.0           360f3f577303   38 minutes ago      750MB
abcdesktopio/oc.template.ubuntu.gtk.language-pack-all   3.0           ffa088de7432   39 minutes ago      1.37GB
abcdesktopio/oc.template.ubuntu.gtk.18.04               3.0           6096b4d7e810   47 minutes ago      844MB
abcdesktopio/oc.template.alpine.gtk                     3.0           c5c5fdb65bb3   50 minutes ago      473MB
abcdesktopio/oc.template.debian.gtk                     3.0           4ac6d8a0a29a   50 minutes ago      935MB
abcdesktopio/oc.template.ubuntu.gtk.20.04               3.0           05d340132498   53 minutes ago      948MB
abcdesktopio/oc.template.ubuntu.gtk                     3.0           05d340132498   53 minutes ago      948MB
abcdesktopio/oc.template.debian                         3.0           8e8e0f18939a   57 minutes ago      313MB
abcdesktopio/oc.template.ubuntu.22.04                   3.0           40acf4266e5d   57 minutes ago      349MB
abcdesktopio/oc.template.ubuntu.20.04                   3.0           b994df5df495   57 minutes ago      340MB
abcdesktopio/oc.template.ubuntu.18.04                   3.0           54e37c5fc10a   57 minutes ago      289MB
abcdesktopio/oc.template.alpine                         3.0           0862f2869cd9   About an hour ago   177MB
abcdesktopio/oc.template.debian.minimal                 3.0           37574f02a006   About an hour ago   268MB
abcdesktopio/oc.template.ubuntu.minimal.22.04           3.0           91a4e2a466b8   About an hour ago   335MB
abcdesktopio/oc.template.ubuntu.minimal.20.04           3.0           1e5d58f8e739   About an hour ago   332MB
abcdesktopio/oc.template.ubuntu.minimal.18.04           3.0           84f228f79697   About an hour ago   245MB
abcdesktopio/oc.template.alpine.minimal                 3.0           8528ff0674c7   About an hour ago   92.8MB
```



## to make template container image for 1.0

```bash
cd oc.template
make
```

`Makefile` build all source template images. 
The default `TAG` is `dev`


## to get more details

Please, read the public documentation web site:
* [https://www.abcdesktop.io](https://www.abcdesktop.io)
* [https://abcdesktopio.github.io/](https://abcdesktopio.github.io/)


