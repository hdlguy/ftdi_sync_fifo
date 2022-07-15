ALL_EXE = stream_test
all: $(ALL_EXE) 

CC=gcc
CFLAGS=  -Wall -I/home/pedro/github/libftdi/src/

DEPS = Makefile

# $@: target file name, $^: all prerequisites,  $<: first prerequisite

VPATH=/home/pedro/github/libftdi/src/

stream_test: stream_test.o ftdi.o ftdi_stream.o
	gcc -g -o $@ $^ -lm -lusb

clean:
	rm -rf *.o $(ALL_EXE) 

#pattern rules
%.o: %.c $(DEPS)
	$(CC) -g -c -o $@ $< $(CFLAGS)


