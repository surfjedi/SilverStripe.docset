require 'nokogiri'

module SilverStripeDocset
  class AbstractDocsetAsset 
    attr_accessor :repo, :folder

    def setup
      fetch()
      produce()
      bundle()
      index()
    end
    
    def fetch
      if File.exists? @folder
        if not system "cd #{folder} && git fetch origin && git reset --hard origin/master"
          raise "Could not update folder."
        end
      else
        system "git clone #{repo} #{folder}"
      end
    end

    def working_folder
      "_working/#{folder}"
    end

    def release_folder
      "_working/SilverStripe.docset/Contents/Resources/#{folder}"
    end

    def produce

    end

    def bundle
      system "rsync --delete #{working_folder} #{release_folder}"
    end

    def index

    end
  end


  class ApiAsset < AbstractDocsetAsset

    def initialize(argv) 
      @repo = "https://github.com/silverstripe/api.silverstripe.org.git"
      @folder = "api"
    end

    def produce
      if not system "#{working_folder}/makedoc.sh"
        raise "Could not execute #{working_folder}/makedoc.sh"
      end
    end
  end 


  class DocAsset < AbstractDocsetAsset
   
    def initialize(argv)
      @repo = "https://github.com/silverstripe/doc.silverstripe.org.git"
      @folder = "doc"
    end

    def index
      Dir.glob("#{release_folder}") do |item|
        doc = Nokogiri::HTML(item)
        name = doc.css("h1").first.content

        @db.execute("INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?,?,?)", name, "Guide", item )
      end
    end
end