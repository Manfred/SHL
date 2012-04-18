# SHL

Simple HTTP Library, because simple is simpler.

    gem install shl

## Example

    response = SHL(:verb => :get, :url => 'http://www.google.com')
    puts response.body