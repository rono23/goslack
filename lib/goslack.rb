require 'google/api_client'
require_relative "goslack/version"
require_relative "goslack/slack"
require_relative "goslack/google"
require_relative "goslack/google/analytics"

class Goslack
  attr_accessor :slack, :google

  def initialize(options = {})
    @slack = Goslack::Slack.new
    @google = Goslack::Google.new
    yield(self) if block_given?
    @google.authorize_client!
  end

  def get_analytics(start_date = Date.today.to_s, end_date = nil)
    end_date = start_date unless end_date
    analytics = @google.client.discovered_api('analytics','v3')
    params = {
      api_method: analytics.data.ga.get,
      parameters: {
        'ids' => ga(@google.analytics.view_id),
        'start-date' => start_date,
        'end-date' => end_date,
        'metrics' => ga(@google.analytics.metrics)
      }
    }
    get(params)
  end

  def get(params)
    result = @google.client.execute(params)

    if result.status == 200
      result.data.rows.flatten
    else
      result.response.body.to_s
    end
  end

  def post(text)
    @slack.post(text)
  end

  def ga(params = {})
    return '' if params.nil? || params.empty?
    prefix = 'ga:'

    if params.is_a? Array
      params.map { |param| prefix + param.to_s }.join(',')
    else
      prefix + params
    end
  end
end
