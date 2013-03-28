require 'rubygems'
require 'mechanize'

# Methods -------------------------------------------------

# Self-explanatory
def get_username

	puts "Enter the username of the user who's prints you'd like to download print images from:"
	puts "Example: xraystyle"
	puts
	puts "Type 'quit' to exit the program.'"
	puts
	print "> "

	response = gets.chomp.strip.downcase

	case response
	when "quit"
		done = ""
	else
		fresh_prints_of_bel_air(response)
	end

end

# Take the input URL and get the images

def fresh_prints_of_bel_air(response)

	username = response	

	@prints_url = "http://" + response + ".deviantart.com/prints/"

	@download_dir = File.expand_path('~/Desktop/downloaded_prints_images/') + "/" + username

	if !File.directory?(File.expand_path(@download_dir))
		FileUtils.mkdir_p(File.expand_path(@download_dir))
	end

	@error_count = 0

	@download_count = 0

	@another_page = true

	page = nil

	@page_num = 2

	until @another_page == false  # Keep moving until last page.

		if page == nil

			begin
				page = @agent.get(@prints_url)	
			rescue => e
				puts e
				@error_count += 1
			end

			matches = page.content.scan(/super_img="(http:\/\/[\S]+)"/)

			puts
			puts "Page 1..."
			puts matches.inspect
			puts "Found #{matches.length} matches."
			puts page.uri
			puts

			if matches
				save_images(matches)
			end
			puts

		else

			link = @agent.page.link_with(:text => 'Next')

			if link.href # If we have an href there's more pages to go.

				begin
					page = @agent.page.link_with(:text => 'Next').click
				rescue => e
					puts e
					@error_count += 1
				end

				matches = page.content.scan(/super_img="(http:\/\/[\S]+)"/)

				puts
				puts "Page #{@page_num}..."
				puts "Found #{matches.length} matches."
				puts page.uri
				puts

				if matches
					save_images(matches)
				end
				puts
				
				@page_num += 1

			else
				@another_page = false # No href? No more pages. 
			end

		end

	end

	puts "#{@download_count} images downloaded with #{@error_count} errors. \nWould you like to download prints for another user? (y/n)"
	puts
	print "> "
	y_n = gets.chomp.strip.downcase
	case y_n
	when "y"
		system 'clear'
		get_username
	else
		done = ""
	end

end

# Save Images from found super_img matches
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
 	 						img.save(filename)
 	 						@download_count +=1
 	 					rescue => e
 	 						puts e
 	 						@error_count += 1
 	 					end
 	 					sleep(2)
 	 					
 	 				end

				end
			end
		end

	end

end


#End Methods --------------------------------------------------------------


#Start script ***

system 'clear'

@agent = Mechanize.new

puts "*" * 10 + "xraystyle's Prints Image Downloader" + "*" * 10
puts
puts

get_username

puts
puts
puts "Done. The images are in a folder on the desktop called 'downloaded_prints_images'."
































