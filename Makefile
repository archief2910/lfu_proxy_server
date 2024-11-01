CC=g++
CFLAGS= -g -Wall 

all: proxy

proxy: prxy_server.cpp
	$(CC) $(CFLAGS) -o proxy_parse.o -c proxy_parse.cpp -lpthread
	$(CC) $(CFLAGS) -o proxy.o -c prxy_server.cpp -lpthread
	$(CC) $(CFLAGS) -o proxy proxy_parse.o proxy.o -lpthread

clean:
	rm -f proxy *.o

tar:
	tar -cvzf ass1.tgz   Makefile proxy_parse.cpp proxy_parse.h prxy_server.cpp
