class PointsController < ApplicationController

  def index

    @points = Point.all

  end

  def create

    @point = Point.create({data: params[:data]})

  end

end
