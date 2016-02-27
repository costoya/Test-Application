# Test-Application

Some unit tests, integration tests and performance tests were added to the project.

## Pre-requisites

To install all gem dependencies:
```
bundle install
```

Performance tests are executed using JMeter (http://jmeter.apache.org/download_jmeter.cgi). 

## Some considerations
### Unit Tests

RSpec was used to cover the unit tests.

### Integration tests

RSpec and Capybara were used to run the integration tests.

### Performance/Load tests

A very basic test using JMeter was created. Basically it starts 5 threads for ever and each thread creates an item. The script includes some graphs to check if there is any performance degradation.

Playing with the number of threads and the duration of the test we can simulate or a performance test or a load/stability test.

## Steps to run tests

To run the unit tests and the integration tests execute following command:
```
bundle exec rspec
```

To run the jmeter test, execute jmeter, load the script and press play.

## Test cases

|Id|Title|Description|
|---|---|---|
|X1|New Item – Happy path|Check that an item can be created.|
|X2|New Item – Empty values|Check if name and description can be empty.|
|X3|New Item – Huge size|Check the behavior when the name and description size is bigger to 255 characters.|
|X4|New Item – Back|Check that back button sends to the main page.|
|X5|Destroy – Happy path|Check that destroy works and deletes the proper element.|
|X6|Destroy – Cancel|Check that if destroy is cancelled nothing is deleted.|
|X7|Edit Item – Happy path|Check that edit works and updated the proper entry.|
|X8|Edit Item – Empty values|Check the behavior of the tool when an entry is edited using an empty value on the name and on the description.|
|X9|Edit Item – Huge size|Check the behavior of the tool when an entry is edited using a huge (bigger to 255 characters) description and name.|
|X10|Edit Item – Back|Check that back button sends to the main page.|
|X11|Edit Item – Show|Check that the show link works properly when a entry is edited.|
|X12|Listing Elements – Happy path|Check that the created elements are listed properly.|
|X13|Listing Elements – Strange characters|Check that the elements with strange characters are shown properly.|
|X14|Listing Elements – Huge |Check that the elements with huge number of characters are shown properly.|
|X15|Show Item – Happy path|Check that the created elements are listed properly.|
|X16|Show Item – Strange characters|Check that the elements with strange characters are shown properly.|
|X17|Show Item – Huge |Check that the elements with huge number of characters (bigger to 255 characters) are shown properly.|
|X18|Show Item – Edit|Check the behavior of the tool when the edit button is clicked showing the details of a page.|
|X19|Performance|Validate that the performance of the tool does not degrade after  inserting a huge number of elements.|
