# About
A simple netcat-based chat application, originally made to be used on a local network when the internet connection goes down and other chat services are unavailable.

# Usage
1. Person 1 runs `server.sh`
2. Person 2 connects with `nc a.b.c.d 9999` where a.b.c.d is the IP address of person 1

BashChat defaults to port 9999, but this can be configured on the command line to avoid conflicts and allows running multiple BashChat sessions from the same computer. e.g. Running on port 9998: `server.sh 9998`
