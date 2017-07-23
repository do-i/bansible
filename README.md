# Bansible ~ Bubble3 Configured By Ansible
### Setup Raspberry Pi with Raspbian Jessie Lite (headless mode)
#### Step 1: Run raspbianizer.sh
- Specify the correct device path to the fresh SD card (e.g. /dev/sdd, /dev/sde, or /dev/sdx)
- Specify the BRANCH variable with correct github branch or release version tag (master, v1.0.0, etc)
- Example:
```sh
export BRANCH=pretty-ui && curl -skL "https://raw.githubusercontent.com/do-i/bansible/${BRANCH}/scripts/raspbianizer.sh" | sudo bash -s /dev/sdx
```

#### Step 2: Boot-up Raspberry Pi3 using SD card & SSH
- Take out the SD card from your computer and put it in Raspberry Pi3
- Check that an ethernet cable(Cat 5) connects between Raspberry Pi3 and the router(has Internet access)
- Ensure that the USB flash drive holding your data is connected to the Pi3 before powering up
- Run Keygen
```sh
ssh-keygen
```
[Help](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)

#### Step 3: Update hosts file
```sh
sudo echo '<IP Address>   pi pi3 bubble' | sudo tee --append /etc/hosts
```

#### Step 4: Transfer rsa public key from your OS to Raspberry Pi3
```sh
cat ~/.ssh/id_rsa.pub | ssh pi@pi3 "mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys"
```
- When it asks you to enter password, enter `raspberry`.
- Optionally you can run `ssh-add` command. This keeps your ssh key in memory to avoid typing password in the next step.

#### Step 5: Install and Configure
Recommend you to use same BRANCH as in Step 1.
```sh
export BRANCH=ui-v2 && curl -skL "https://raw.githubusercontent.com/do-i/bansible/${BRANCH}/install.sh" | bash
```
- Tip: This install command should be executed on your OS. (Not on raspberry pi3.)
- Note: Thanks for a [great instructional article](https://frillip.com/using-your-raspberry-pi-3-as-a-wifi-access-point-with-hostapd) for WiFi configuration.
- Override Options
  - WIFI SSID (alphanumeric 1-32 characters)
  ```sh
  export SSID=MyBubble
  ```
  - WPA Passphrase (alphanumeric 8-63 characters)
  ```sh
  export PASS=MySecretPassPhrase2016
  ```
- Note: When you see this `Enter passphrase for key '/home/<username>/.ssh/id_rsa':` enter the passphrase you used to create key in Step 2.

#### Step 6: Check for Errors & Reboot
- Check for any errors. If everything looks good, move on to the final step.

#### Step 7: Connect
- Disconnect ethernet cable from Raspberry Pi3
- Connect your device(s) to WiFi Access Point (If you did not override SSID and PASS in Step 3, here are default values.)
  - SSID: SimpleBubble
  - PASS: raspberry
- Open your web browser on [http://bubble](http://bubble "bubble") or [IP address](http://2.4.6.16)
