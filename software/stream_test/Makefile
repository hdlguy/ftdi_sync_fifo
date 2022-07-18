ALL_EXE = stream_test
all: $(ALL_EXE) 

CC=gcc
CFLAGS=-Wall -I/home/pedro/github/libftdi/src/ -I/usr/include/libusb-1.0/ -I/home/pedro/github/libftdi/build/src/
#LFLAGS=-L./lib

DEPS = Makefile

# $@: target file name, $^: all prerequisites,  $<: first prerequisite

VPATH=/home/pedro/github/libftdi/src/

stream_test: stream_test.o ftdi.o ftdi_stream.o
	gcc -g -o $@ $^ -lm -lusb -lusb-1.0

clean:
	rm -rf *.o $(ALL_EXE) 

#pattern rules
%.o: %.c $(DEPS)
	$(CC) -g -c -o $@ $< $(CFLAGS)


