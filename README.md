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
