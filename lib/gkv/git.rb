module Gkv
  module GitFunctions
    extend self

    def hash_object(data)
      write_tmpfile(data)
      hash = `git hash-object -w tmp.txt`.strip!
      File.delete('tmp.txt')
      hash
    end

    def write_tmpfile(data)
      f = File.open('tmp.txt', 'w+')
      f.write(data)
      f.close
    end

    def cat_file(hash)
      `git cat-file -p #{hash}`
    end
  end

  module DbFunctions
    def update_items(key, value)
      if $ITEMS.keys.include? key
        history = $ITEMS[key]
        history << Gkv::GitFunctions.hash_object(value)
        $ITEMS[key] = history
      else
        $ITEMS[key] = [Gkv::GitFunctions.hash_object(value)]
      end
    end
  end
end
