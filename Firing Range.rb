Shoes.app :title => "Firing Range", :width => 300, :height => 300 do #these are criteria for the window
	stack do # vertical stack
		flow do #horizontal flow of elements
			caption "Start at: "
			edit_box do |e| # http://shoesrb.com/manual/EditBox.html
				@counter.text = e.text.size
			end
		end # back in the stack
		@counter = strong("0")
			para @counter, " characters" 
	end
end