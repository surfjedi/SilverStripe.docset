#
# doc.silverstripe.org 
# 
require_relative "abstract"

module SilverStripeDocset
  class DocAsset < AbstractDocsetAsset
     
    def initialize(working, db)
      @repo = "https://github.com/silverstripe/doc.silverstripe.org.git"
      @folder = "doc"
      
      super
    end

    def produce
      if not system "#{assets_tmp}/bin/update.sh"
        raise "Could not execute #{assets_tmp}/bin/update.sh"
      end
    end

    def bundle
      # delete stuff we don't need
      system "rm -rf #{assets_tmp}/cache/framework/en/2.3"
      system "rm -rf #{assets_tmp}/cache/framework/en/2.4"
      system "rm -rf #{assets_tmp}/cache/framework/en/3.0"
      system "rm -rf #{assets_tmp}/cache/framework/en/trunk"
      system "rm -rf #{assets_tmp}/cache/framework/en/changelogs"

      system "rsync --delete -rv #{assets_tmp}/cache/framework/en/ #{release_folder}"
    end

    def index
      Dir.glob("#{release_folder}/**/*.html") do |item|
        doc = Nokogiri::HTML(open(item))
        name = doc.css("h1").first.content
        path = item.sub("#{release_folder}", "").sub("/", "").strip()

        @db.execute("INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?,?,?)", name, "Guide", path )
      end
    end
  end
end