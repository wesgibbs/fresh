#  1. Start an instance of Chrome with port 9222 open
#    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222 --user-data-dir="./ChromeProfile"
#  2. Manually navigate that browser instance to the "No delivery windows availabe" page
#  3. In a second terminal run `bundle exec ruby ./fresh.rb`
#
#  Delivery times appeared between 6:50 AM and 7:15 AM last time.

require 'pry-byebug'
require 'selenium-webdriver'
require 'time'

options = Selenium::WebDriver::Chrome::Options.new
options.add_option("debuggerAddress", "127.0.0.1:9222")
driver = Selenium::WebDriver.for(:chrome, options: options)
matches = [1]

puts "Began at #{Time.now.strftime("%H:%M")}"

begin
  while !matches.empty? do
    print "."
    driver.navigate.refresh
    Selenium::WebDriver::Wait.new(:timeout => 8).until { driver.find_element(:class, "a-button-input").enabled? }
    matches = driver.find_elements(:xpath, "//*[normalize-space(text()) = 'No delivery windows available. New windows are released throughout the day.']")
    message = "Delivery times may be available" if matches.empty?
    sleep 5
  end
rescue Selenium::WebDriver::Error::TimeOutError
  message = "Reload failed"
end

while true do
  `afplay /System/Library/Sounds/Submarine.aiff`
  `say "#{message}"`
  sleep 5
end

driver.quit
