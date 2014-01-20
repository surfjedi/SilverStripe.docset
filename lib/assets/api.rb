#
# api.silverstripe.org
#
#
require_relative "abstract"

module SilverStripeDocset
  class ApiAsset < AbstractDocsetAsset

    def initialize(working, db)
      @repo = "https://github.com/silverstripe/api.silverstripe.org.git"
      @folder = "api"

      @release_branch = "master" # one api branch

      super
    end

    def produce
      if not system "#{assets_tmp}/makedoc.sh"
        raise "Could not execute #{assets_tmp}/makedoc.sh"
      end
    end

    def bundle
      system "rsync --delete -rv #{assets_tmp}/htdocs/#{release_version}/ #{release_folder}"
    end

    def index
      Dir.glob("#{release_folder}/class-*.html") do |item|
        doc = Nokogiri::HTML(open(item))

        name = doc.css("h1").first.content.sub('Class ', "").strip()
        path = item.sub("#{release_folder}", "").sub("/", "").strip()
        path = 
        # add the class
        @db.execute("INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?,?,?)", 
          name, 
          "Class", 
          File.join(@folder, path) 
        )

        # add the methods
        doc.css('#methods .name code a').each do |link|
          if link[:href]
            @db.execute("INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?,?,?)", 
              link.content, 
              "Method", 
              File.join(@folder, link[:href])
            )
          end
        end

        # add the properties
        doc.css('#properties .name a var').each do |link|
          if link[:href]
            @db.execute("INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?,?,?)", 
              link.content, 
              "Property", 
              File.join(@folder, link[:href])
            )
          end
        end
      end
    end
  end 
end