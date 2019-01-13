# Bansible ~ Bubble3 Configured By Ansible
### Setup Raspberry Pi with Raspbian Strech Lite (headless mode)

#### Step 0: Download Raspbian Strech Lite OS
- Download OS from https://www.raspberrypi.org/downloads/raspbian/ to home directory

#### Step 1: Run raspbianizer.sh
- Specify the correct device path to the fresh SD card (e.g. /dev/sdd, /dev/sde, or /dev/sdx)
- Specify the BRANCH variable with correct github branch or release version tag (master, v1.0.0, etc)
- Specify WIFI_SSID and WIFI_PASS which has Internet connection.
- Example:
```sh
export BRANCH=release-branch-2019.01.13 && curl -skL "https://raw.githubusercontent.com/do-i/bansible/${BRANCH}/scripts/raspbianizer.sh" | sudo WIFI_SSID="changeme" WIFI_PASS="changeit" bash -s /dev/sdx ~/2018-11-13-raspbian-stretch-lite.zip
```

#### Step 2: Boot-up Raspberry Pi 3 Model A+ using SD card & SSH
- Take out the SD card from your computer and put it in Raspberry Pi 3 Model A+
- Ensure that the USB flash drive holding your data is connected to the Pi 3 before powering up
- SSH into Bubble

#### Step 3: Install and Configure (Run on Bubble)
Recommend you to use same BRANCH as in Step 1.
```sh
export BRANCH=release-branch-2019.01.13 && curl -skL "https://raw.githubusercontent.com/do-i/bansible/${BRANCH}/install_local.sh" | sudo BRANCH="${BRANCH}" bash
```
- Note: Thanks for a [great instructional article](https://frillip.com/using-your-raspberry-pi-3-as-a-wifi-access-point-with-hostapd) for WiFi configuration.
- Override Options
  - WIFI SSID (alphanumeric 1-32 characters)
  ```sh
  export SSID=MyBubble
  ```
  - WPA Passphrase (alphanumeric 8-63 characters)
  ```sh
  export PASS=MySecretPassPhrase2020
  ```

#### Step 4: Check for Errors & Reboot
- Check for any errors. If everything looks good, move on to the final step.

#### Step 5: Connect
- Disconnect ethernet cable from Raspberry Pi3
- Connect your device(s) to WiFi Access Point (If you did not override SSID and PASS in Step 3, here are default values.)
  - SSID: SimpleBubble
  - PASS: raspberry
- Open your web browser on [http://bubble](http://bubble "bubble") or [IP address](http://2.4.6.16)
