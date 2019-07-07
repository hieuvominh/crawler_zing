require "net/http"
require "uri"
require "nokogiri"

HOME_URL = "https://news.zing.vn/"

uri = URI.parse(HOME_URL)
response = Net::HTTP.get_response(uri)
doc = Nokogiri::HTML(response.body)
link = doc.css('a').map { |link| link['href'] }

for i in (0...link.size-1)
	a = link[i].include? "html"
	if !a
		link[i] = nil
	end
end
link = link.compact
link.pop
out_file = File.new("out.html", "w")
link.each do |e|
	article = Net::HTTP.get_response(URI.parse(HOME_URL + e))
	ele = Nokogiri::HTML(article.body)
	cont = ele.css('.main')
	out_file.puts(cont)
end
out_file.close
