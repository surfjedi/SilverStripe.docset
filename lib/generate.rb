require 'nokogiri'
require 'fileutils'
require 'sqlite3'
require 'rainbow'
require 'optparse'

require_relative "assets/api"
require_relative "assets/doc"

module SilverStripeDocset
  class Generate
    attr_accessor :working, :use_working, :base

    def initialize(opts)
      @base = File.expand_path("../../", __FILE__)
      @working = File.join(@base, "_working")

      @use_working = opts[:use_working]

      setup_docset()

      @db = SQLite3::Database.new("#{database_path}")
      @db.execute('DROP TABLE IF EXISTS searchIndex;')
      @db.execute('CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);')
      @db.execute('CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);')

      @api = SilverStripeDocset::ApiAsset.new(@working, @db);
      @doc = SilverStripeDocset::DocAsset.new(@working, @db);
    end

    def run
      @api.run(@use_working)
      @doc.run(@use_working)

      produce_release()
    end

    def contents_path
      "#{working}/SilverStripe.docset/Contents"
    end

    def database_path
      "#{contents_path}/Resources/docSet.dsidx"
    end

    def documents_path
      "#{contents_path}/Resources/Documents"
    end

    def produce_release
      system "tar --exclude='.DS_Store' -cvzf #{working}/SilverStripe.docset.tgz #{working}/SilverStripe.docset"
    end

    def setup_docset
      puts "Creating working directory #{working}"

      FileUtils.mkdir_p "#{documents_path}"

      ["Info.plist"].each do |f|
        FileUtils.cp "#{base}/#{f}", "#{contents_path}/#{f}"
      end

      [ "icon.png"].each do |f|
        FileUtils.cp "#{base}/#{f}", "#{working}/SilverStripe.docset/#{f}"
      end
      
      ["index.html", "icon.png", "style.css"].each do |f|
        FileUtils.cp "#{base}/#{f}", "#{documents_path}/#{f}"
      end
    end
  end
end