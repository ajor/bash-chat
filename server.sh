#/bin/sh

host_name=host
client_name=client

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

move_cursor_up() {
  printf '\033[1A'
}

server() {
  echo "Starting on port $port"
  tail -f $output | nc -l -p $port > $input
  echo server ending
}

receive() {
  printf '%s: ' "$client_name" > $output
  local message
  while IFS= read -r message; do
    clear_line
    printf '\033[0;36m%s: \033[0;39m%s\n%s: ' "$client_name" "$message" "$host_name"
    move_cursor_up > $output
    clear_line > $output
    printf '\033[0;37m%s: \033[0;39m%s\n%s: ' "$client_name" "$message" "$client_name" > $output
  done < $input
  echo receive ending
}

chat() {
  printf '%s: ' "$host_name"
  local message
  while [ 1 ]; do
    IFS= read -r message
    clear_line > $output
    printf '\033[0;36m%s: \033[0;39m%s\n%s: ' "$host_name" "$message" "$client_name" > $output
    move_cursor_up
    clear_line
    printf '\033[0;37m%s: \033[0;39m%s\n%s: ' "$host_name" "$message" "$host_name"
  done;
  echo chat ending
}

read -r -p 'Enter username: ' host_name
server &
echo 'Waiting for client to join...'
printf 'Enter username: ' > $output
read -r client_name < $input
echo "$client_name has joined the chat"
echo "Joined $host_name's chat" > $output
receive &
chat
