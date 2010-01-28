class Markov 

  def initialize(dir)
    @users = {}
    @file = Array.new
    
    Dir.open(dir).entries.each do |file|
      next if file[0..0] == "."
      next unless file == "GarryDanger.txt"
      @users[file.split(".")[0]] = process file
    end
  end

  def process(file)
    ngrams = {}
    File.open(file) do |f|
      while (line = f.gets)
        tokens = ['.'].concat(line.split(' ')).push('.')
	# puts tokens.inspect
	0.upto( tokens.length) do |i|
	  i.upto([i+3, tokens.length].min).each do |j|
	    target = tokens[j]
	    window=tokens[i..j-1]
	    ngrams[window] ||= []
	    ngrams[window] << target
	  end
	end
      end
    end
    return ngrams
  end

  def markov(user, context) 
    ngrams = @users[user]
    if ngrams.nil?
      return "Don't know, sorry"
    end
    while context
      # puts ngrams.inspect
      arr=ngrams[context]
      if arr && arr.length > 1 
        return arr[rand(arr.length)]
      end
      return "ran out, should never happen" if context.empty?
      context.shift
    end
  end
  def continued(user, context)
    ws = []
    1000.times do
      w=markov(user,context)
      ws.push(w)
      context.unshift
      context.push(w)
    end
    puts ws.join(' ')
  end
end

m = Markov.new(".")

m.continued("GarryDanger", ["."])
