class Obstacle
  include Processing::Proxy

  attr_accessor :location

  def initialize(x, y, width, height)
    @location = PVector.new(x, y)
    @width = width
    @height = height
  end

  def display
    stroke(0)
    fill(175)
    stroke_weight(2)
    rect_mode(CORNER)
    rect(@location.x, @location.y, @width, @height)
  end

  def contains?(spot)
    ((spot.x > @location.x) and
     (spot.x < @location.x + @width) and
     (spot.y > @location.y) and
     (spot.y < @location.y + @height))
  end
end
