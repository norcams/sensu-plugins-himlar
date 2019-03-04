#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'rest-client'
require 'json'

class ForemanErrors < Sensu::Plugin::Check::CLI
  option :endpoint,
         short: '-e URL',
         long: '--endpoint URL',
         default: 'https://localhost/api'

  option :user,
         short: '-u USER',
         long: '--user USER',
         default: 'admin'

  option :password,
         short: '-p PASSWORD',
         long: '--password PASSWORD',
         default: 'changeme'

  option :password,
         short: '-p PASSWORD',
         long: '--password PASSWORD',
         default: 'changeme'

  option :verify_ssl,
         short: '-v',
         long: '--verify-ssl',
         default: false

  option :warning,
         short: '-w NUM',
         long: '--warning NUM',
         description: 'Warning if NUM hosts are failing',
         default: 1

  option :critical,
         short: '-c NUM',
         long: '--critical NUM',
         description: 'Warning if NUM hosts are failing',
         default: 10

  def get_errors(username, password, url, verify_ssl)
    begin
      client = RestClient::Resource.new(
        url,
        user: username,
        password: password,
        headers: { accept: :json },
        verify_ssl: verify_ssl
      )
      results = client['hosts'].get(
        params: {
          per_page: 10_000,
          search: "last_report > \"65 minutes ago\"
                   and (status.failed > 0 or status.failed_restarts > 0)
                   and status.enabled = true"
        }
      )
      hostnames = JSON.parse(results)['results'].map { |h| h['name'] }
      return hostnames.count
    rescue Exception => e
      critical "Cannot connect to Foreman API: #{e}"
    end
  end

  def run
    count = get_oos(config[:user],
                    config[:password],
                    config[:endpoint],
                    config[:verify_ssl])
    if count > config[:warning]
      warning "#{count} hosts have errors"
    elsif count > config[:critical]
      critical "#{count} hosts have errors"
    else
      ok 'We are within the threshold'
    end
  end
end
