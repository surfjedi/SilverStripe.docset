require 'nokogiri'

module SilverStripeDocset
  class AbstractDocsetAsset 
    attr_accessor :repo, :folder, :release_version, :assets_tmp
    attr_reader :db, :working_dir

    def initialize(working, db)
      @working_dir = working
      @release_version = '3.1'
      @release_branch = @release_version
      
      @assets_tmp = "#{working_dir}/#{folder}"

      @db = db
    end

    def run(use_working)
      if not use_working
        fetch()
        produce()
      end

      bundle()
      index()
    end
  
    def fetch
      if File.exists? "#{assets_tmp}"
        if not system "cd #{assets_tmp} && git fetch origin && git reset --hard origin/#{release_branch}"
          raise "Could not update folder."
        end
      else
        system "git clone #{repo} #{assets_tmp}"
      end
    end

    def release_folder
      "#{working_dir}/SilverStripe.docset/Contents/Resources/Documents/#{folder}"
    end

    def produce
      raise "Unimplemented produce method"
    end

    def bundle
      raise "Unimplemented index method"
    end

    def index
      raise "Unimplemented index method"
    end
  end
end