guard :rspec, cmd: 'bundle exec rspec' do
	# watch them lib files
	watch(%r{^lib/(.+).rb}) do |match|
		"spec/#{match[1]}_spec.rb"
	end

	# watch them spec files too
	watch(%r{^(spec/.+_spec\.rb)}) do |match|
		"#{match[1]}"
	end
end