require 'nokogiri'
require 'fileutils'
require 'sqlite3'

require "assets"

module SilverStripeDocset
  WORKING = '../_working'


  class Generate
    def initialize(argv)
      @db = SQLite3::Database.new("#{database_path}")
      @db.execute('DROP TABLE searchIndex;')
      @db.execute('CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);')
      @db.execute('CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);')

      @api = SilverStripeDocset::ApiAsset.new();
      @doc = SilverStripeDocset::DocAsset.new();
    end

    def run
      setup_docset()

      @api.setup()
      @doc.setup()

      @produce_release()
    end

    def contents_path
      "#{WORKING}/SilverStripe.docset/Contents"
    end

    def database_path
      "#{contents_path}/Resources/docSet.dsidx"
    end

    def documents_path
      "#{contents_path}/Resources/Documents"
    end

    def produce_release
      system "tar --exclude='*.pdf' --exclude='.DS_Store' -cvzf SilverStripe.docset.tgz #{WORKING}/SilverStripe.docset"
    end

    def setup_docset
      FileUtils.mkdir_p "#{documents_path}"
      FileUtils.cp "assets/Info.plist", "#{contents_path}/Info.plist"
    end
  end
end