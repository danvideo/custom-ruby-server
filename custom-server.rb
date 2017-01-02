require './morse'
class CustomServer

  require 'socket'

  def start_server(listen_port)
    server = TCPServer.new listen_port
    connections = 0
    begin
    loop do
      Thread.start(server.accept) do |client|
        connections += 1
        puts "Connection ##{connections} @ #{Time.now}" 
        sock_domain, remote_port, remote_hostname, remote_ip = client.peeraddr
        remote_header = client.recvmsg.first
        client.puts "\n\nHello! \n\n"
        client.puts "This is your IP address: #{remote_ip}\n\n"
        client.puts "This is your IP in Morse code: #{ip_to_morse(remote_ip)}\n\n"
        client.puts "This is your request Header: \n\n#{remote_header}\n"
        client.close
      end
    end
    rescue Errno::ECONNRESET, Errno::EPIPE => e
      puts e.message
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
 
puts "\n*Attention* please include a port # when calling the server\n\n" unless ARGV[0]
CustomServer.new.start_server(ARGV[0]) if ARGV[0]