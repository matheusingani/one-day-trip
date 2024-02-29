class PagesController < ApplicationController
  def home
    @places = Place.all
    @markers = @places.geocoded.map do |place|
      {
        lat: place.latitude,
        lng: place.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {place: place})
      }
    end

    def show_one_place_per_city
      allplaces = Place.all
      #uniq { |obj| obj.name }.max_by { |obj| obj.rating }
      @placepercity = allplaces.group_by { |place| place.city }
    end

    show_one_place_per_city


  end
end
