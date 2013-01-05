Shoes.app :title => "Firing Range", :width => 300, :height => 300 do #these are criteria for the window
	stack do # vertical stack

		flow do #horizontal flow of elements
			caption "Start at: "
			edit_box :height => 30 do |e| # http://shoesrb.com/manual/EditBox.html
				@counter.text = e.text.size
			end
		end # back in the stack

		flow do 
			caption "End at:  "
			edit_box :height => 30 do |e|
				@counter2.text = e.text()
			end

		end
		@counter = strong( "0" )
		@counter2 = strong( "0" )
			para @counter, " what ", @counter2

		button "Submit" do
			alert '@counter is the size, and @counter2 is the actual contents. *\o/*'
			end
		
	end
end