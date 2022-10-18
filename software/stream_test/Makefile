ALL_EXE = stream_test
all: $(ALL_EXE) 

CC=gcc
CFLAGS=-Wall -I$(HOME)/github/libftdi/src/ -I$(HOME)/github/libftdi/build/src/ -I/usr/include/libusb-1.0/ 

DEPS = Makefile

# $@: target file name, $^: all prerequisites,  $<: first prerequisite

VPATH=$(HOME)/github/libftdi/src/

stream_test: stream_test.o ftdi.o ftdi_stream.o
	gcc -g -o $@ $^ -lm -lusb -lusb-1.0

clean:
	rm -rf *.o $(ALL_EXE) 

#pattern rules
%.o: %.c $(DEPS)
	$(CC) -g -c -o $@ $< $(CFLAGS)


