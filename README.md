# MacSwap

MacSwap allows you to quickly and easily change your MAC address. This can be useful in a variety of situations, all of which are accommodated for by MacSwap. The script is for educational purposes and should not be misused.

See [MacSwapPy](https://github.com/Tommrodrigues/MacSwapPy) for a new streamlined version of this script

## Usage

Download and run the script with:
```
git clone https://github.com/Tommrodrigues/MacSwap.git
bash ~/MacSwap/MacSwap.sh
```

The script is fairly easy to use, simply run it using the command above and enter your `sudo` password when prompted. After running the script, you will be given the following options:

![Example](https://i.ibb.co/9n3JjJq/Screenshot-2018-12-06-at-14-39-57.png)

For more information on the options, read below:

| Name | Description |
| --- | --- |
| Bypass login page | Allows you to connect to a network which requires registration. This directly clones a MAC address connected to the network. |
| Bypass restriction | Allows you to connect to a network which filters which types of devices can connect to a network. This clones a MAC address already connected to the network with the exception of the last two characters. |
| Random | This will randomise your MAC address. This can be helpful when avoiding MAC address tracking (e.g. in airports). |
| Custom | Allows you to choose your own MAC address. |
| Reset | Will simply reset your MAC address to its true value. |

## Notes

- For options 1 and 2, you must connect to the desired network for a short period of time before running the script (typically 30 seconds or so) in order to capture pre-existing MAC addresses on the network.

- Your MAC address automaticlly resets after restarting your computer so take this into consideration when spoofing.
