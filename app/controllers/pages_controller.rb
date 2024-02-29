class PagesController < ApplicationController
  def home
    @places = Place.all
    @markers = @places.geocoded.map do |place|
      {
        lat: place.latitude,
        lng: place.longitude
      }
    end

    def show_one_place_per_city
      allplaces = Place.all
      #uniq { |obj| obj.name }.max_by { |obj| obj.rating }
      @placepercity = allplaces.group_by { |place| place.city }
    end

    show_one_place_per_city

    # get rating with place_id from experience table
    # sort it places array according to that ratings average
    # display only the first one

#     SELECT date_trunc('month', purchased_at)::date, SUM(orders_with_amount.amount)
# FROM orders
# JOIN orders_with_amount ON orders.id = orders_with_amount.order_id
# GROUP BY 1

    def show_best_rated_place
      @places = Place.all
      if params[:query].present?
        sql = <<~SQL
          movies.title ILIKE :query
          OR movies.synopsis ILIKE :query
          OR directors.first_name ILIKE :query
          OR directors.last_name ILIKE :query
        SQL
      @movies = @movies.joins(:director).where(sql, query: "%#{params[:query]}%")
      end
    end

  end
end
