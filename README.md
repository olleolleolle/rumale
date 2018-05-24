# SVMKit

[![Build Status](https://travis-ci.org/yoshoku/SVMKit.svg?branch=master)](https://travis-ci.org/yoshoku/SVMKit)
[![Coverage Status](https://coveralls.io/repos/github/yoshoku/SVMKit/badge.svg?branch=master)](https://coveralls.io/github/yoshoku/SVMKit?branch=master)
[![Gem Version](https://badge.fury.io/rb/svmkit.svg)](https://badge.fury.io/rb/svmkit)
[![BSD 2-Clause License](https://img.shields.io/badge/License-BSD%202--Clause-orange.svg)](https://github.com/yoshoku/SVMKit/blob/master/LICENSE.txt)

SVMKit is a machine learninig library in Ruby.
SVMKit provides machine learning algorithms with interfaces similar to Scikit-Learn in Python.
SVMKit currently supports Linear / Kernel Support Vector Machine,
Logistic Regression, Ridge, Lasso, Factorization Machine, Naive Bayes, Decision Tree, Random Forest,
K-nearest neighbor classifier, and cross-validation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'svmkit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install svmkit

## Usage

Training phase:

```ruby
require 'svmkit'

samples, labels = SVMKit::Dataset.load_libsvm_file('pendigits')

normalizer = SVMKit::Preprocessing::MinMaxScaler.new
normalized = normalizer.fit_transform(samples)

transformer = SVMKit::KernelApproximation::RBF.new(gamma: 2.0, n_components: 1024, random_seed: 1)
transformed = transformer.fit_transform(normalized)

classifier = SVMKit::LinearModel::SVC.new(reg_param: 1.0, max_iter: 1000, batch_size: 20, random_seed: 1)
classifier.fit(transformed, labels)

File.open('trained_normalizer.dat', 'wb') { |f| f.write(Marshal.dump(normalizer)) }
File.open('trained_transformer.dat', 'wb') { |f| f.write(Marshal.dump(transformer)) }
File.open('trained_classifier.dat', 'wb') { |f| f.write(Marshal.dump(classifier)) }
```

Testing phase:

```ruby
require 'svmkit'

samples, labels = SVMKit::Dataset.load_libsvm_file('pendigits.t')

normalizer = Marshal.load(File.binread('trained_normalizer.dat'))
transformer = Marshal.load(File.binread('trained_transformer.dat'))
classifier = Marshal.load(File.binread('trained_classifier.dat'))

normalized = normalizer.transform(samples)
transformed = transformer.transform(normalized)

puts(sprintf("Accuracy: %.1f%%", 100.0 * classifier.score(transformed, labels)))
```

5-fold cross-validation:

```ruby
require 'svmkit'

samples, labels = SVMKit::Dataset.load_libsvm_file('pendigits')

kernel_svc = SVMKit::KernelMachine::KernelSVC.new(reg_param: 1.0, max_iter: 1000, random_seed: 1)

kf = SVMKit::ModelSelection::StratifiedKFold.new(n_splits: 5, shuffle: true, random_seed: 1)
cv = SVMKit::ModelSelection::CrossValidation.new(estimator: kernel_svc, splitter: kf)

kernel_mat = SVMKit::PairwiseMetric::rbf_kernel(samples, nil, 0.005)
report = cv.perform(kernel_mat, labels)

mean_accuracy = report[:test_score].inject(:+) / kf.n_splits
puts(sprintf("Mean Accuracy: %.1f%%", 100.0 * mean_accuracy))
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshoku/svmkit.
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [BSD 2-clause License](https://opensource.org/licenses/BSD-2-Clause).

## Code of Conduct

Everyone interacting in the SVMKit project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yoshoku/svmkit/blob/master/CODE_OF_CONDUCT.md).
