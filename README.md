# IP Auditor

The IP Auditor looks through your Apache vhosts to compile a list of apps on the server, what domains are being listened for and what IP each domain is actually pointing to.

If passenger is installed, it also lists where the rails apps are located and what rvm gemset / rails version they are using.

This allows you to quickly track which domains and apps are active and which are pointing elsewhere.

## Assumptions

* RVM is installed on the server, and the bin path is `/usr/local/rvm/bin/rvm`
* Apache vhost files are located in `/etc/apache2/site-enabled/`
* Apache vhost files follow the `site-name.com` convention
* If passenger is installed, site config files are stored in `/etc/passenger.d/`
* Passenger files follow the `site-name.com.yml` convention

## Installation

	gem install ip_auditor

## Usage

	audit_ips [server name/IP] [user] [options]

## Options

* `-p [PORT NUMBER]` Specify a port number (default is 22)
* `-c [FILE NAME (optional)]` Output to .csv file instead of terminal (can specify a name)
* `-v` Output more information as to what's happening
* `-e [prod|stage|dev|etc.]` Specify an environment to output (defaults to 'all'; determined by passenger config files, so non-rails site will always return)

### Examples

Basic usage:
```audit_ips someserver.com my_user -p 8080```

Print to "IP Audit - someserver.com.csv":
```audit_ips someserver.com my_user -p 8080 -c```

Print to "IP Audit - my audit.csv":
```audit_ips someserver.com my_user -p 8080 -c "my audit"```

## Terminal Output

The Auditor will return a crude report for each VirtualHost in the following format.

	============
	[Site Name]
	============
	[Rails Environment]
	[Directory]
	[Gemset]
	[Rails Version]
	[Virtual Host (IP:port)]

	------------
	Site Statuses
	------------
	[domain-1]
	[IP domain-1 is actually pointing to]

	[domain-2]
	[IP domain-2 is actually pointing to]

	etc.

## CSV Output

If the -c flag is set, Auditor will create a .csv file instead of printing data to the terminal.

The csv file will have the following columns:
Site, Environment, Directory, Gemset, Rails Version, Virtual Host, Site Statuses

The Site Statuses column will actually just be the begnning of a list of sites and the IP's they are pointing to.

## Contributing

Pull requests are welcome!

To build and run gem locally:

* build gem
`gem build ip_auditor.gemspec`

* uninstall old version
`gem uninstall ip_auditor`

* install from local build
`gem install ip_auditor-0.0.2.gem`

## License

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.