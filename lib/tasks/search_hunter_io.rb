module Intrigue
module Task
class SearchHunterIo < BaseTask

  def self.metadata
    {
      :name => "search_hunter_io",
      :pretty_name => "Search Hunter.io",
      :authors => ["jcran"],
      :description => "This task hits the Hunter.io API. Email Addresses are created.",
      :references => [],
      :type => "discovery",
      :passive => true,
      :allowed_types => ["Domain"],
      :example_entities => [{"type" => "Domain", "details" => {"name" => "intrigue.io"}}],
      :allowed_options => [],
      :created_types => ["EmailAddress"]
    }
  end

  ## Default method, subclasses must override this
  def run
    super

    api_key = _get_task_config("hunter_io_api_key")
    unless api_key 
      _log_error "unable to proceed, no API key for hunter.io provided"
      return
    end

    domain_name = _get_entity_name

    url = "https://api.hunter.io/v2/domain-search?domain=#{domain_name}&api_key=#{api_key}&limit=1000" 

    response = http_get_body(url)
    JSON.parse(response)["data"]["emails"].each do |e|
      _create_entity "EmailAddress", "name" => e["value"], "hunterio" => e
    end

  end # end run()

end # end Class
end
end
