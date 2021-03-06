require 'rest-client'
require 'nokogiri'

class Scribd
  
  attr_accessor :query, :url
  
  def initialize
    services = YAML::load_file(File.join(Rails.root, 'config', 'services.yml'))
    @query = {:api_key => services['scribd']}
    @url = "http://api.scribd.com/api"
  end
  
  def upload(file, extension)
    return self.fake_upload(file, extension) if Rails.env.test?
    response = RestClient.post @url, {:file => file, :doc_type => extension, :method => "docs.upload"}.merge(@query)
    xml = Nokogiri::XML(response)
    begin
      doc_id = xml.search('doc_id').first.content
      access_key = xml.search('access_key').first.content
      {:doc_id => doc_id, :access_key => access_key}
    rescue
      false
    end
  end
  
  def fake_upload(file, extension)
    {:doc_id => "scribd-doc-#{rand(Time.now.to_i)}", :access_key => "key-#{rand(Time.now.to_i)}"}
  end
  
  def download(document)
    response = RestClient.get @url, :params => {:method => "docs.getDownloadUrl", :doc_type => document.extension, :doc_id => document.scribd_doc_id}.merge(@query)
    xml = Nokogiri::XML(response)
    begin
      xml.search('download_link').first.content.strip
    rescue
      false
    end
  end
  
  def upload_from_url(url)
    response = RestClient.post @url, {:url => url, :method => "docs.uploadFromUrl"}.merge(@query)
    xml = Nokogiri::XML(response)
    begin
      doc_id = xml.search('doc_id').first.content
      access_key = xml.search('access_key').first.content
      {:doc_id => doc_id, :access_key => access_key}
    rescue
      false
    end
  end
end