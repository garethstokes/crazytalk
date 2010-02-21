import Directory
import qualified Data.Map as Map
import List
import Maybe
import System.Random

type Corpus = Map.Map Context [String]
type Context = [String]

markov :: Corpus -> Context -> Int -> [String]
markov corpus context limit = take limit $ concat $ mapMaybe findNgrams $ tails context
  where findNgrams x = Map.lookup x corpus

buildCorpus :: [[String]] -> Corpus
buildCorpus l = undefined

loop :: Int -> Corpus -> Context -> IO ()
loop 0 corpus context = putStrLn "... and done!"
loop n corpus context = do
  res  <- pick $ markov corpus context 5
  putStrLn res
  loop (n-1) corpus (tail context ++ [res] )
  
pick :: [a] -> IO a
pick a = do r <- getStdRandom (randomR (1, length a))
	    return $ a !! (r-1)

main = do
  contents <- getContents
  let corpus = buildCorpus $ map words $ lines contents
  loop 1000 corpus ["start", "out", "here"]
  
{-
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
      e1Gnd
      return "ran out, should never happen" if context.empty?
      context.shift
    end
  end
  def continued(user, context)
    ws = []
    1000.times do
      w=markov(user,context)
      sws.push(w)
      context.unshift
      context.push(w)
    end
    puts ws.join(' ')
  end
end

m = Markov.new(".")

m.continued("GarryDanger", ["."])
-}
