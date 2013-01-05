Shoes.app :title => "Firing Range", :width => 300, :height => 300 do #these are criteria for the window
	stack do # vertical stack
		flow do #horizontal flow of elements
			caption "Start at: "
			@start_counter = edit_line
			#edit_box :height => 30, :width => 50 do |e| # http://shoesrb.com/manual/EditBox.html
			#	@start_counter.text = e.text.size
			#end
			#@counter = text("0")
			#para @counter
		end # back in the stack
		flow do
		caption "End at:  "
		 
			edit_box :height => 30, do |e|
				@end_counter = e.text
			end
		end
		#@counter = strong("0")
			para @start_counter.size, ", and ending at ", @end_counter
		button "Submit" do
			alert @start_counter.text

		end

	end
end