# frozen_string_literal: true

module FitbitClient
  module Resources
    module BodyAndWeight
      # The Get Weight Logs API retrieves a list of all user's body weight log
      # entries for a given day using units in the unit systems which
      # corresponds to the Accept-Language header provided.
      #
      # Body weight log entries are available only to authorized user.
      #
      # Body weight log entries in response are sorted exactly the same as they
      # are presented on the Fitbit website.
      def weight_logs(date, options = {})
        get_json(path_user_version("/body/log/weight/date/#{iso_date(date)}"))
      end

      # The Log Weight API creates log entry for a body weight using units in
      # the unit systems that corresponds to the Accept-Language header provided
      # and get a response in the format requested.
      #
      # <b>Note:</b> The returned Weight Log IDs are unique to the user,
      # but not globally unique.
      #
      #   weight : Weight in the format X.XX
      #   date   : Date of the measurement
      #   time   : Time of the measurement
      def log_weight(weight, date, time = nil, options = {})
        if time
          params = { 'weight' => weight, 'date' => iso_date(date), 'time' => iso_time_with_seconds(time) }
        else
          params = { 'weight' => weight, date => iso_date(date) }
        end
        post_json(path_user_version('/body/log/weight', options), params)
      end

      # The Delete Weight Log API deletes a user's body weight log entry with
      # the given ID.
      def delete_weight_log(body_weight_log_id, options = {})
        path = "/body/log/weight/#{body_weight_log_id}"
        successful_delete?(delete(path_user_version(path, options)))
      end

      # Retrieves a user's current body fat percentage or weight goal using
      # units in the unit systems that corresponds to the Accept-Language header
      # provided in the format requested.
      #
      #   goal_type : can be weight or fat
      def body_goals(goal_type, options = {})
        get_json(path_user_version("/body/log/#{goal_type}/goal", options))
      end

      # The Update Body Fat Goal API creates or updates user's fat percentage
      # goal.
      #
      #   fat : Target body fat percentage in the format X.XX
      def update_body_fat_goal(fat, options = {})
        post_json(path_user_version('/body/log/fat/goal', options), 'fat' => fat)
      end

      # The Update Weight Goal API creates or updates user's fat or weight goal
      # using units in the unit systems that corresponds to the Accept-Language
      # header provided in the format requested.
      #
      #   startDate   : Weight goal start date
      #   startWeight : Weight goal start weight; in the format X.XX
      #   weight      : Weight goal target weight; in the format X.XX, in the
      #                 unit systems that corresponds to the Accept-Language
      #                 header provided; required if user doesn't have an existing
      #                 weight goal.
      def update_body_weight_goal(start_date, start_weight, weight = nil, options = {})
        if weight
          params = { 'startDate' => iso_date(start_date), 'startWeight' => start_weight, 'weight' => weight }
        else
          params = { 'startDate' => iso_date(start_date), 'startWeight' => start_weight }
        end
        post_json(path_user_version('/body/log/weight/goal', options), params)
      end

      # The Get Body Time Series API returns time series data in the specified
      # range for a given resource in the format requested using units in the
      # unit systems that corresponds to the Accept-Language header provided.
      #
      # <b>Note:</b> If you provide earlier dates in the request, the response
      # retrieves only data since the user's join date or the first log entry
      # date for the requested collection.
      #
      #   resource_path      : Can be "bmi", "fat", or "weight".
      #   date               : The range start date or end date of the period specified
      #   period_or_end_date : One of  1d, 7d, 30d, 1w, 1m, 3m, 6m, 1y, max or the end date of the range
      def body_time_series(resource_path, date, period_or_end_date, options = {})
        end_limit = period_or_end_date.is_a?(Date) ? iso_date(period_or_end_date) : period_or_end_date
        path = "/body/#{resource_path}/date/#{iso_date(date)}/#{end_limit}"
        get_json(path_user_version(path, options))
      end

      # The Get Body Fat Logs API retrieves a list of all user's body fat log
      # entries for a given day in the format requested. Body fat log entries
      # are available only to authorized user.
      #
      # If you need to fetch only the most recent entry, you can use the
      # Get Body Measurements endpoint.
      #
      #   date               : base or start date
      #   period_or_end_date : One of 1d, 7d, 1w, 1m or a Date object
      def body_fat_logs(date, period_or_end_date = nil, options = {})
        if period_or_end_date
          end_limit = period_or_end_date.is_a?(Date) ? iso_date(period_or_end_date) : period_or_end_date
          path = "/body/log/fat/date/#{iso_date(date)}/#{end_limit}"
        else
          path = "/body/log/fat/date/#{iso_date(date)}"
        end
        get_json(path_user_version(path, options))
      end

      # The Log Body Fat API creates a log entry for body fat and returns a
      # response in the format requested.
      #
      # <b>Note:</b> The returned Body Fat Log IDs are unique to the user, but
      # not globally unique.
      #
      #   fat  : Body fat; in the format X.XX
      #   date : Log entry date
      #   time : Time of the measurement
      def log_body_fat(fat, date, time = nil, options = {})
        if time
          params = { 'fat' => fat, 'date' => iso_date(date), 'time' => iso_time_with_seconds(time) }
        else
          params = { 'fat' => fat, 'date' => iso_date(date) }
        end
        post_json(path_user_version('/body/log/fat', options = {}), params)
      end

      # The Delete Body Fat Log API deletes a user's body fat log entry with
      # the given ID.
      #
      # <b>Note:</b> A successful request returns a 204 status code with an
      # empty response body.
      def delete_body_fat_log(body_fat_log_id, options = {})
        successful_delete?(delete(path_user_version("/body/log/fat/#{body_fat_log_id}", options)))
      end
    end
  end
end
