# require "ip_auditor/version"
require 'net/ssh'

module IpAuditor
  # puts ARGV[0]
  server = ARGV[0] || ''
  port = ARGV[1] || 22
  user = ARGV[2] || ''
  pass = ARGV[3] || ''

  Net::SSH.start(server, user, {port: port, password: pass}) do |ssh|

    # find lines of interest in vhosts, assumes location is /etc/apache2/sites-enabled
    domain_text = ssh.exec!("grep -r '<VirtualHost\\|DocumentRoot\\|ServerName\\|ServerAlias' /etc/apache2/sites-enabled")
    
    # loop trough each line of results
    domain_text.each_line do |line|
      # output VirtualHost
      puts "\n============\n"+line+"============" if line['<VirtualHost']
      # output DocumentRoot
      puts line.scan(/DocumentRoot(.*)/).to_a[0][0].strip if line['DocumentRoot']

      # if line is a ServerName or ServerAlias
      domain_line = line.scan(/(ServerName|ServerAlias)(.*)/).to_a
      if domain_line[0]
        # pull out domains and loop through them
        domains = domain_line[0][1].strip.split(' ')
        domains.each do |domain|
          # output domain
          puts domain if domain
          # perform an nslookup
          lookup = `nslookup #{domain}`

          # strip output to IPs only
          output = lookup.scan(/(Non-authoritative answer:)(.*)/m).to_a
          ips = output[0][1].scan(/Address: (.*)/).to_a if output[0]

          # output results
          if ips
            puts ips
          else
            puts 'DOMAIN LOOKUP FAILED'
          end
        end
      end
    end

  end

end
