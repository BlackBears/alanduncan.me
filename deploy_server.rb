require 'socket'

server = TCPServer.open 2468
puts "Listening on port 2468"

loop {
	client = server.accept()

	lines = []
	while line = client.gets and line !~ /^\s*$/
		lines << line.chomp
	end

	Thread.new {
		system 'osascript /Users/alan/Documents/dev/scripts+tools/applescript/scripts/active/sync-blog-s3.scpt'
	}
	

	resp = lines.join("<br />")
	headers = ["http/1.1 200 ok",
		"date: tue, 14 dec 2010 10:48:45 gmt",
		"server: ruby",
		"content-type: text/html; charset=iso-8859-1",
		"content-length: #{resp.length}\r\n\r\n"].join("\r\n")
	  client.puts headers          # send the time to the client
	  client.puts resp
	  client.close
	}