Shoes.app(:title => "Firing Range", :width => 300, :height => 300 ) do 
	background lightslategray
	fill lightblue
	rect(:center => false, :top => 5, :left => 5, :height => 280, :width => 280, :curve => 12)

	stack :margin => 10 do # vertical stack

		flow do #horizontal flow of elements
			caption "Start at: "
			edit_box :height => 30, :width => 150 do |e| 
				@counter.text = e.text()
				start = @counter.text.to_s
			end
		end # back in the stack

		flow do 
			caption "End at:  "
			edit_box :height => 30, :width => 150 do |e|
				@counter2.text = e.text()
				ending = @counter2.text.to_s
			end
		end
		
	end

		@counter = strong( "0" )
		@counter2 = strong( "0" )
		para "Closing ticket range ", @counter, " to ", @counter2, "."
		stack :margin => 10, do 
		button "Submit" do
			content = system('powershell C:\scripts\Close-Range.ps1 #{start} #{ending}')
			
		end
	end
end
