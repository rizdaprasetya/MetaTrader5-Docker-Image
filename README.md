# MetaTrader5 Docker Image

This project provides a Docker image for running MetaTrader5 with remote access via VNC, based on the [KasmVNC](https://github.com/kasmtech/KasmVNC) project and [KasmVNC Base Images from LinuxServer](https://github.com/linuxserver/docker-baseimage-kasmvnc).

## Features

- Run MetaTrader5 in an isolated environment.
    - Optionally MetaTrader4 is also supported, but you have to put the file manually.
- Remote access to MetaTrader5 interface via an integrated VNC client accessible through a web browser.
- Built on the reliable and secure KasmVNC project.

## Requirements

- Docker installed on your machine.

## Usage
### A. Recommended Usage via Docker Compose
1. Clone this repository:
```bash
git clone https://github.com/gmag11/MetaTrader5-Docker-Image
cd MetaTrader5-Docker-Image
```
2. Create a new empty file named `.env` (or rename `.env.example` to `.env`).
3. A convenient way to run and manage the container is by running it via Docker Compose:
```bash
docker compose up --build -d
```

4. Then you can access MetaTrader5 via a web browser at localhost:3000.

- Later on:
    - After first time running with `--build` next time running you can ommit it, so just `docker compose up -d`
    - To stop the container: `docker compose stop`
    - Or to further remove/clean up the container (will not remove volume persisted data): `docker compose down`

Or alternatively if you just need to run via docker (without compose), follow below.

### B. Normal Usage Via Docker Run
1. Clone this repository:
```bash
git clone https://github.com/gmag11/MetaTrader5-Docker-Image
cd MetaTrader5-Docker-Image
```

2. Build the Docker image:
```bash
docker build -t mt5 .
```

3. Run the Docker image (simpler version):
```bash
docker run -d -p 3000:3000 -v config:/config mt5
```

Now you can access MetaTrader5 via a web browser at localhost:3000.

- To make it easier to do future operations to the container, assign a name to it by adding `--name mymt5container` argument :
```bash
docker run --name mymt5container -d -p 3000:3000 -v config:/config mt5
```    
- Which then later can be stopped with:
```bash
docker stop mymt5container
```

## Configuration
The port configuration can be adjusted as per the instructions [in the KasmVNC repository](https://github.com/linuxserver/docker-baseimage-kasmvnc). Any additional configuration or environment variables needed to customize MetaTrader5 and KasmVNC running settings should be described here.

Tips: for changing the exposed KasmVNC http web interface port, easier to change from the docker command or compose's yml file. e.g. if I want the exposed port to be accessible via `localhost:1234`, then I change:
- the `docker run`'s command arg of `-p 3000:3000` part to e.g. `-p 1234:3000`; or
- the `docker.compose.yml` file's port of `- 3000:3000` to `1234:3000`.

### Optional Environment Files
There is `.env.example` file which is a template to configure your own (optionl) `.env` (environment vars) file. For example, copy `.env.example` file into `.env`, then edit/add any necessary env variables. e.g. to change KasmVNC username & password:
```bash
CUSTOM_USER=username
PASSWORD=securepassword
```
Note: if unset, `abc` as HTTP Basic auth username; and blank as HTTP Basic auth password.
Based on [KasmVNC base image's options table](https://github.com/linuxserver/docker-baseimage-kasmvnc/blob/6a8e07cf5e7933e0832ada20b153f17e31696f97/README.md#options).

## Persisted Data/Volume
### PersistedData Folder
MetaTrader 5 install folder (which is "C:/Program Files/MetaTrader 5/" within the Docker container) will be persisted to /`./config/.wine/drive_c/Program Files/MetaTrader 5` folder (within this repo folder, wherever you cloned it to. Which means persisted outside of the Docker Container).

This is useful for (example) use cases of:
- If you already have a pre-installed MetaTrader 5 on your actual PC, and you want to transfer it to this container, (after cloning/downloading this repo) you can create  `./config/.wine/drive_c/Program Files/MetaTrader 5` folder, and just copy the content of your own "C:/Program Files/MetaTrader 5/" to it, then run the container, the container will run it.
    - Tips: To make your PC's MT5 Portable, you may need to first [ran it using "portable mode" argument](https://www.metatrader5.com/en/terminal/help/start_advanced/start#:~:text=appropriate%20section.-,Portable%20Mode,-When%20installed%20to) first on your PC, before transfering it to the container's persisted data folder.
    - Note: each time container run, it will check "C:/Program Files/MetaTrader 5/terminal64.exe", if already exist will run it; else will download & install a new MT5 (and probably overwrite the MT5 folder).
- If you want to transfer the MT5 installed within the container back to your PC (or wherever), you can (will be safer to first stop the container, then) copy the content of `./config/.wine/drive_c/Program Files/MetaTrader 5` back to your PC.
- Or if you want to add/modify/rename file contents of the MT5 folder (like adding EA/Indicator files, etc.) without running the container, you can do it via `./config/.wine/drive_c/Program Files/MetaTrader 5` folder.
- Can also prepare your own MT5 folder, (ensure that `.config` is removed frm `.gitignore` file) then Git Commit to the repo, so you can use Git to quickly store/load your (various) desired MT5 setups.
- Can also add more windows programs to run via `./config/.wine/drive_c/Program Files/` folder. e.g. useful if you want add MetaTrader 4. But to make sure you have the corresponding desktop shortcut, you should edit and add it in `./root/defaults/menu.xml` file (then re-build the docker image after), for example add to the item list (after line 5):
```xml
...
<item label="Metatrader 4" icon="/config/.wine/drive_c/Program Files/MetaTrader 4/Terminal.ico"><action name="Execute"><command>/usr/bin/wine "/config/.wine/drive_c/Program Files/MetaTrader 4/terminal.exe" "/portable"</command></action></item>
...
```

#### MetaTrader 4
- Optionally MetaTrader4 is currently already supported, but you have to put the file manually within folder `./config/.wine/drive_c/Program Files/MetaTrader 4`, ignore it if you don't need it.

## config Folder
(After running the container at least once) Within this repo folder there will be `./config` folder. Which is a persisted folder from `/config` root folder within the container, is contains a lot more. Like the `.wine` folder (Note: Wine is the emulator used on linux to run Windows apps), where Windows app emulated files is stored. Which again you can also find the MT5 install folder in `./config/.wine/drive_c/Program Files/MetaTrader 5` (though a bit longer to access than `./PersistedData` folder above).

## Contributions
Feel free to contribute to this project. All contributions are welcome. Open an issue or create a pull request.

## License

This project is licensed under the terms of the [MIT license](https://opensource.org/license/mit/). 

The **KasmVNC** project is licensed under the [GNU General Public License v2.0 (GPLv2)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html). You can check the license details of KasmVNC [here](https://github.com/kasmtech/KasmVNC/blob/master/LICENSE.TXT).

**KasmVNC Base Images from LinuxServer** is licensed unther the GNU General Public License v3.0 (GPLv3). License is available [here](https://github.com/linuxserver/docker-baseimage-kasmvnc/blob/master/LICENSE)

Please ensure to comply with the terms and conditions of the licenses while using or modifying this project.

# Acknowledgments
Acknowledgments to the [KasmVNC](https://github.com/kasmtech/KasmVNC) project, [KasmVNC Base Images from LinuxServer](https://github.com/linuxserver/docker-baseimage-kasmvnc/tree/master) and any other project or individual that contributed to the realization of this project.
