#! /usr/bin/env ruby
#
#   check-imagebuild
#
# DESCRIPTION:
# check if imagebuild failed
#
require 'sensu-plugin/check/cli'
require 'jsonl'

class CheckImagebuild < Sensu::Plugin::Check::CLI
  option :distro,
         short: '-d distro'

  def run
    file = "/var/log/imagebuilder/#{config[:distro]}-report.jsonl"
    if File.exist?(file)
      distro = File.basename(file).sub(/\-.*$/, "")
      begin
        parsed_jsonl = JSONL.parse(File.read(file))
      rescue
        parsed_jsonl = nil
      end
      if parsed_jsonl
        merged_hash = parsed_jsonl.reduce({}, :merge)
        result = merged_hash['result']
      else
        result = 'invalid'
      end
    else
      result = 'invalid'
    end
    if result.include? "failed"
      critical "#{distro_build} failed!"
    elsif result.include? "success"
      ok "#{distro_build} success!"
    elsif result.include? "invalid"
      warning "#{distro_build} warning!"
    end
  end
end
