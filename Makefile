CC=gcc
CPP=g++
CFLAGS=-O2
LDFLAGS=$(CFLAGS)

CFLAGS += -fopenmp
#LDFLAGS += -lpthread

MAPFLAGS += -DENABLE_OPENMP
#MAPFLAGS += -DENABLE_PTHREADS
#MAPFLAGS += -DLIBMAPPING_WITH_PAPI

all: full_shared_no_lock.o full_shared_no_lock_perfect.o
	$(CC) -o full_shared_no_lock full_shared_no_lock.o $(LDFLAGS)
	$(CC) -o full_shared_no_lock_perfect full_shared_no_lock_perfect.o $(LDFLAGS)

full_shared_no_lock.o:
	$(CC) -c full_shared_no_lock.c $(CFLAGS) -I../libmapping $(MAPFLAGS)

full_shared_no_lock_perfect.o:
	$(CC) -c full_shared_no_lock.c -o full_shared_no_lock_perfect.o $(CFLAGS) -I../libmapping -DPERFECT_REMAP $(MAPFLAGS)

clean:
	- rm *.o
	- rm full_shared_no_lock
	- rm full_shared_no_lock_perfect
