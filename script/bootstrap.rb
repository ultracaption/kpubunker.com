#!/usr/bin/env ruby

APP_PATH = File.expand_path('../../config/application',  __FILE__)
require File.expand_path('../../config/boot',  __FILE__)

require File.expand_path('../lectures', __FILE__)

@lectures.each do |lecture|
  Lecture.create do |record|
    record.title = lecture[0]
    record.provider = lecture[1]
  end
end

# Import to Elasticsearch index
Lecture.import
