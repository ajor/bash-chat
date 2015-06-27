#/bin/sh

host_name=Alastair
client_name=Other

if [ $# -ge 1 ]; then
  port=$1
else
  port=9999
fi

input=/tmp/chat-receive-$port
output=/tmp/chat-sending-$port

rm -f $input
rm -f $output
mkfifo $input
mkfifo $output

clear_line() {
  printf '\r\033[2K'
}

server() {
  echo server starting
  tail -f $output | nc -l -p $port > $input
  echo server ending
}

receive() {
  echo receive starting
  printf '%s: ' "$client_name" > $output
  local message
  while read message; do
    clear_line
    printf '%s: %s\n%s: ' "$client_name" "$message" "$host_name"
    printf '%s: ' "$client_name" > $output
  done < $input
  echo receive ending
}

chat() {
  echo chat starting
  printf '%s: ' "$host_name"
  local message
  while [ 1 ]; do
    read message
    clear_line > $output
    printf '%s: %s\n%s: ' "$host_name" "$message" "$client_name" > $output
    printf '%s: ' "$host_name"
  done;
  echo chat ending
}

server &
receive &
chat
