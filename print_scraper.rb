require 'rubygems'
require 'mechanize'

def save_images(image_matches)

	img_agent = Mechanize.new
	image_matches.each do |match|
		match.each do |item|
			basename = item.scan(/\/{1}([^\/]+$)/)
			basename.each do |a|
				a.each do |b|
 	 				filename = @download_dir.to_s + "/" + b
 	 				
 	 				if !File.exist?(filename)
 	 					puts "Downloading #{match[0]}..."
 	 					begin
 	 						img = img_agent.get(match[0])
 	 					rescue => e
 	 						puts e
 	 					end
 	 					sleep(1)
 	 					img.save(filename)
 	 				end

				end
			end
		end

	end

end




system 'clear'

@agent = Mechanize.new

puts "xraystyle's Prints Image Downloader"
puts
puts

puts "Enter the URL of the user who's prints you'd like to download print images from:"
puts "Example: http://xraystyle.deviantart.com"

response = gets.chomp.strip.downcase

@prints_url = response + "/prints/"

@download_dir = File.expand_path('~/Desktop/downloaded_prints_images/')

if !File.directory?(File.expand_path('~/Desktop/downloaded_prints_images/'))
	FileUtils.mkdir(File.expand_path('~/Desktop/downloaded_prints_images/'))
end

@a = 0

page = nil

@page_num = 2

until @a == 1

	if page == nil

		begin
			page = @agent.get(@prints_url)	
		rescue => e
			puts e
		end
		

		matches = page.content.scan(/super_img="(http:\/\/[\S]+)"/)

		puts "Page 1..."
		puts page.uri
		puts

		sleep(5)


		if matches
			save_images(matches)
		end

	else

		link = @agent.page.link_with(:text => 'Next')

		if link.href

			sleep(5)

			begin
				page = @agent.page.link_with(:text => 'Next').click
			rescue => e
				puts e
			end
			

			matches = page.content.scan(/super_img="(http:\/\/[\S]+)"/)

			puts "Page #{@page_num}..."
			puts page.uri
			puts

			if matches
				save_images(matches)
			end
			
			@page_num += 1

		else
			@a = 1
		end

	end

end

puts "Done. The images are in a folder on the desktop called 'downloaded_prints_images'."
































