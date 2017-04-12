puts "SSD Console -h for help"
puts " "
puts " "

def colorize(text, color_code)
  "#{color_code}#{text}e[0m"
end

def red(text); colorize(text, "e[31m"); end
def green(text); colorize(text, "e[32m"); end

# Actual work
puts 'Importing categories [ ' + green('DONE') + ' ]'
# Actual work
puts 'Importing tags       [' + red('FAILED') + ']'

# Handle the input, this would probably run some method
# as a part of the DSL you'd have to create. Place this
# repl as your command line interface to your service.
def handle_input(input)
  result = eval(input)
  puts(" => #{result}")
end

# This is a lambda that runs the content of the block
# after the input is chomped.
repl = -> prompt do
  begin
    print prompt
    handle_input(gets.chomp!)
  rescue "Error"
    raise "ERROR"
  end
end

# After evaling and returning, fire up the prompt lambda
# again, this loops after every input and exits with
# exit or a HUP.
loop do
  repl["SSD> "]
end
