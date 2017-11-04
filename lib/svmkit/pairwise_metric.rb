module SVMKit
  # Module for calculating pairwise distances, similarities, and kernels.
  module PairwiseMetric
    class << self
      # Calculate the pairwise euclidean distances between x and y.
      #
      # @param x [NMatrix] (shape: [n_samples_x, n_features])
      # @param y [NMatrix] (shape: [n_samples_y, n_features])
      # @return [NMatrix] (shape: [n_samples_x, n_samples_x] or [n_samples_x, n_samples_y] if y is given)
      def euclidean_distance(x, y = nil)
        y = x if y.nil?
        sum_x_vec = (x**2).sum(1)
        sum_y_vec = (y**2).sum(1)
        dot_xy_mat = x.dot(y.transpose)
        distance_matrix = dot_xy_mat * -2.0 +
                          sum_x_vec.repeat(y.shape[0], 1) +
                          sum_y_vec.transpose.repeat(x.shape[0], 0)
        distance_matrix.abs.sqrt
      end

      # Calculate the rbf kernel between x and y.
      #
      # @param x [NMatrix] (shape: [n_samples_x, n_features])
      # @param y [NMatrix] (shape: [n_samples_y, n_features])
      # @param gamma [Float] The parameter of rbf kernel, if nil it is 1 / n_features.
      # @return [NMatrix] (shape: [n_samples_x, n_samples_x] or [n_samples_x, n_samples_y] if y is given)
      def rbf_kernel(x, y = nil, gamma = nil)
        y = x if y.nil?
        gamma ||= 1.0 / x.shape[1]
        distance_matrix = euclidean_distance(x, y)
        ((distance_matrix**2) * -gamma).exp
      end

      # Calculate the linear kernel between x and y.
      #
      # @param x [NMatrix] (shape: [n_samples_x, n_features])
      # @param y [NMatrix] (shape: [n_samples_y, n_features])
      # @return [NMatrix] (shape: [n_samples_x, n_samples_x] or [n_samples_x, n_samples_y] if y is given)
      def linear_kernel(x, y = nil)
        y = x if y.nil?
        x.dot(y.transpose)
      end

      # Calculate the polynomial kernel between x and y.
      #
      # @param x [NMatrix] (shape: [n_samples_x, n_features])
      # @param y [NMatrix] (shape: [n_samples_y, n_features])
      # @param degree [Integer] The parameter of polynomial kernel.
      # @param gamma [Float] The parameter of polynomial kernel, if nil it is 1 / n_features.
      # @param coef [Integer] The parameter of polynomial kernel.
      # @return [NMatrix] (shape: [n_samples_x, n_samples_x] or [n_samples_x, n_samples_y] if y is given)
      def polynomial_kernel(x, y = nil, degree = 3, gamma = nil, coef = 1)
        y = x if y.nil?
        gamma ||= 1.0 / x.shape[1]
        (x.dot(y.transpose) * gamma + coef)**degree
      end

      # Calculate the sigmoid kernel between x and y.
      #
      # @param x [NMatrix] (shape: [n_samples_x, n_features])
      # @param y [NMatrix] (shape: [n_samples_y, n_features])
      # @param gamma [Float] The parameter of polynomial kernel, if nil it is 1 / n_features.
      # @param coef [Integer] The parameter of polynomial kernel.
      # @return [NMatrix] (shape: [n_samples_x, n_samples_x] or [n_samples_x, n_samples_y] if y is given)
      def sigmoid_kernel(x, y = nil, gamma = nil, coef = 1)
        y = x if y.nil?
        gamma ||= 1.0 / x.shape[1]
        (x.dot(y.transpose) * gamma + coef).tanh
      end
    end
  end
end