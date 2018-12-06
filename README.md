# MacSwap
#### Change your MAC address quickly and easily

## What is it?

MacSwap allows you to easily change you MAC address for your Mac. This can be useful in a variety of cases, all of which accommodated for by MacSwap.

## Usage

Download and run the script with:
```
git clone https://github.com/Tommrodrigues/MacSwap
bash ~/MacSwap/MacSwap.sh
```

The script is fairly easy to use, simply run it using the command above to recieve the standart output. After running the script, you will be prompted to choose an option:

![Example](https://i.ibb.co/9n3JjJq/Screenshot-2018-12-06-at-14-39-57.png)


For more information on the options, read below:

| Number | Name | Description |
| --- | --- | --- |
| 1 | Bypass login page | Allows you to connect to a network which would otherwise require registration. This clones a MAC address already connected to the network. |
| 2 | Bypass restriction | Allows you to connect to a network which may filter which types of devices can connect to a network. This clones a MAC address already connected to the network with the exception of the last two characters. |
| 3 | Random | As the name implies, this will randomise your MAC address. This can be helpful in avoiding MAC address tracking like in airports. |
| 4 | Custom | Self explanatory, allows you to choose your own MAC address. |
| 5 | Reset | Will simply reset your MAC address to its true value. |

**NOTE:** For options 1 and 2, you must connect to the desired network for a short period of time before running the script (typically 30 secondds). This is in order to capture a pre-existing MAC address on the network.

## Removal

```
sudo rm -r ~/MacSwap
```
