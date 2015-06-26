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

server() {
  echo server starting
  tail -f $output | nc -l -p $port > $input
  echo server ending
}

receive() {
  echo receive starting
  while read message; do
    full_message=`echo "$client_name: $message"`
    echo $full_message
    printf '\033[1A%s\n' "$full_message" > $output
  done < $input
  echo receive ending
}

chat() {
  echo chat starting
  while [ 1 ]; do
    read message
    full_message=`echo "$host_name: $message"`
    echo $full_message > $output
    printf '\033[1A%s\n' "$full_message"
  done;
  echo chat ending
}

server &
receive &
chat
