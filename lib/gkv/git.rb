require 'parser/current'

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
      f.write(data.to_s)
      f.close
    end

    def cat_file(hash)
      `git cat-file -p #{hash}`
    end
  end

  module DbFunctions
    class BlankSlate
      instance_methods.each do |name|
        class_eval do
          unless name =~ /^__|^instance_eval$|^binding$|^object_id$/
            undef_method(name)
          end
        end
      end
    end

    def update_items(key, value)
      if $items.keys.include? key
        history = $items[key]
        history << Gkv::GitFunctions.hash_object(value.to_s)
        $items[key] = history
      else
        $items[key] = [Gkv::GitFunctions.hash_object(value.to_s)]
      end
    end
  end
end
