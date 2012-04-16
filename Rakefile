desc "Run all tests"
task(:default){Dir.glob('test/*_test.rb').each{|f|sh"ruby #{f}"}}
desc "Return the number of bytes in the main implementation file"
task(:size){`wc -c lib/shl.rb`=~/^\s+(\d+)\s/;puts"#{$1} bytes"}