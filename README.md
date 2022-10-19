# ftdi_sync_fifo
An attempt to use the synchronous fifo mode of the FTDI FT2232H USB transceiver.

Testing is done with git://developer.intra2net.com/libftdi.  Stream_test puts the FT2232H into sync fifo mode and captures data from it.

libftdi requires these:

 sudo apt install libusb-1.0-0
 sudo apt install libusb-1.0-0-dev

