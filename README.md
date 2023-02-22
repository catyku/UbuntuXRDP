# UbuntuXRDP 

### modify from https://github.com/danchitnis/container-xrdp ubuntu-xfce

add chinese fonts and ibus ime 

add firefox 

### build docker image
```
docker build -t imagename . 
```

### run image
```
docker run -d --name containerName -p 3389:3389 imagename createUser password rootYesNo
```
like this

```
docker run -d --name rdp -p 3389:3389 ubuntuxrdp ubuntu ubuntu123 yes
```

### more information 
https://github.com/danchitnis/container-xrdp
