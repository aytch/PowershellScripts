def ps_args {
	@arg1 = @counter.text
	@arg2 = @counter2.text
	@results = system('powershell C:\PowerShellScripts\Close-Range.ps1 #{@arg1} #{@arg2}')
	alert @results
}

Shoes.app(:title => "Firing Range", :width => 300, :height => 300 ) do #these are criteria for the window
	stack do # vertical stack

		flow do #horizontal flow of elements
			caption "Start at: "
			edit_box :height => 30 do |e| # http://shoesrb.com/manual/EditBox.html
				@counter.text = e.text()
			end
		end # back in the stack

		flow do 
			caption "End at:  "
			edit_box :height => 30 do |e|
				@counter2.text = e.text()
			end
		end
		@counter = strong( "0" )
		@counter2 = strong( "" )
		para @counter, " what? ", @counter2, "."

		button "Submit" do
			ps_args()
		end
	end
end

