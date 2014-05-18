# Slimerjs-Gem
## Work in progress

This is basically a knock off of the [PhantomJS Gem](https://github.com/colszowka/phantomjs-gem) for [SlimerJS](http://slimerjs.org/)

This supports both the [standalone edition](http://slimerjs.org/download.html#standalone) and the [lightweight edition](http://slimerjs.org/download.html#lightweight).

## Installation

Add this line to your application's Gemfile:

    gem 'slimerjs'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slimerjs

## Example

```ruby
# Standalone
require 'slimerjs'

# Lightweight
require 'slimerjs/lighweight'
```

### Lightweight Edition Additional Configuration

From the [slimerjs documentation](http://docs.slimerjs.org/current/installation.html#setup)

During its launch, SlimerJS tries to discover itself the path of Firefox or XulRunner. This is not a problem for the Standalone edition or linux packages.

In case it fails (this could be the case for the lightweight edition),
or if you want to launch SlimerJS with a specific version of Firefox, you should create an environment variable containing the path of the
Firefox/XulRunner binary. To create this environment variable from a command line:

* on linux:<br>
    `export SLIMERJSLAUNCHER=/usr/bin/firefox`
* on Windows<br>
    `SET SLIMERJSLAUNCHER="c:\Program Files\Mozilla Firefox\firefox.exe"`
* On windows with cygwin<br>
    `export SLIMERJSLAUNCHER="/cygdrive/c/program files/mozilla firefox/firefox.exe"`
* On MacOS<br>
    `export SLIMERJSLAUNCHER=/Applications/Firefox.app/Contents/MacOS/firefox`

You can of course set this variable in your `.bashrc`, `.profile` or in the computer properties on Windows.

## Contributing

1. Fork it ( https://github.com/tarebyte/slimerjs-gem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Thanks

To [Chris Olszowka](https://github.com/colszowka) for the [PhantomJS Gem](https://github.com/colszowka/phantomjs-gem) which
has had a heavy influence on this project.

## Copyright

(c) 2014 Mark Tareshawty

Note that this project merely simplifies the installation of the entirely separate SlimerJS project via a Ruby gem.
You can find the license information for SlimerJS at [http://slimerjs.org/](http://slimerjs.org/)
