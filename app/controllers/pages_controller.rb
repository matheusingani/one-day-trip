class PagesController < ApplicationController
  def home
    @places = Place.all
    show_one_place_per_city
    @markers = @places.geocoded.map do |place|
      {
        lat: place.latitude,
        lng: place.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {place: place})
      }
    end
  end

  def show_one_place_per_city
    @placepercity = Place.last
    #uniq { |obj| obj.name }.max_by { |obj| obj.rating }
    puts @placepercity
  end

end
