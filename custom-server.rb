require './morse'
class CustomServer

  require 'socket'

  def start_server(listen_port)
    server = TCPServer.new listen_port
    connections = 0
    loop do
      Thread.start(server.accept) do |client|
        connections += 1
        puts "Connection ##{connections} @ #{Time.now}" 
        sock_domain, remote_port, remote_hostname, remote_ip = client.peeraddr
        remote_header = client.recvmsg.first
        client.puts "Hello !"
        client.puts "This is your IP address: #{remote_ip}"
        client.puts "This is your IP in Morse code: #{ip_to_morse(remote_ip)}"
        client.puts "This is your request Header: \n#{remote_header}"
        client.close
      end
    end
  end

  def ip_to_morse(ip_address)
    output = ""
    ip_address.split("").each do |num|
      output << MORSE_DICT[num]
    end
    output
  end
end

CustomServer.new.start_server(ARGV[0])