class PointsController < ApplicationController

  protect_from_forgery :except => [:create]

  def index

    @points = Point.all

  end

  def create

    puts params

    @point = Point.create({data: params[:data]})

  end

end
