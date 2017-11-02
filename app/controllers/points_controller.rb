class PointsController < ApplicationController

  protect_from_forgery :except => [:create]

  def index

    @points = Point.all

  end

  def json

    # Self-explanatory
    render json: Point.all

  end

  def create

    # POST Endpoint for receiving data from the client
    @point = Point.create({data: params[:data]})

  end

end
