#! /usr/bin/env ruby
#
#   check-file-exists
#
# DESCRIPTION:
# Simple file check

require 'sensu-plugin/check/cli'

class CheckFileExists < Sensu::Plugin::Check::CLI
  option :file,
         short: '-f /path/to/file',
         long: '--file /path/to/file',
         default: '/'
  option :severity,
         short: '-s severity',
         long: '--severity severity',
         description: 'Severity of missing file. Either W (warning) or C (critical)',
         default: 'C'

  def run
    unless File.exist?(config[:file])
      if config[:severity] == 'C'
        critical "#{config[:file]} missing!"
      elsif config[:severity] == 'W'
        warning "#{config[:file]} missing!"
      else
        unknown "#{config[:file]} missing!"
      end
    else
      ok 'Test file exist'
    end
  end
end
