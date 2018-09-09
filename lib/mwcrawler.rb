require "mwcrawler/version"
require 'nokogiri'
require 'pry'
require 'open-uri'
require 'json'

require 'mwcrawler/classes'
require 'mwcrawler/courses'
require 'mwcrawler/departments'
require 'mwcrawler/helpers'
require 'mwcrawler/crawler'


module Mwcrawler
  class Crawler
    include Mwcrawler

    def start(option)
      menu option
    end
  end
end