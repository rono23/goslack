class Goslack
  class Google
    class Analytics
      attr_accessor :dimensions, :metrics, :sort, :view_id

      def initialize(options = {})
        @metrics = [:pageviews, :visitors]
        @dimensions = [:day, :month]
        @sort = [:day, :month]

        yield(self) if block_given?
      end
    end
  end
end
