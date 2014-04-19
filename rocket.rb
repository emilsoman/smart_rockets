class Rocket
  include Processing::Proxy

  attr_accessor :velocity

  def initialize(x, y)
    @size = 30
    @location = PVector.new(x, y)
    @velocity = PVector.new
  end

  def update
    @location.add(@velocity)
    draw
  end

  def draw
    fill(200, 100)
    stroke(0)
    stroke_weight(1)
    push_matrix

    translate(@location.x, @location.y)

    # Thrusters
    rect_mode(CENTER)
    fill(0)
    rect(-@size/2, @size*2, @size/2, @size)
    rect(@size/2, @size*2, @size/2, @size)

    # Rocket body
    fill(175)
    begin_shape(TRIANGLES)
    vertex(0, -@size*2)
    vertex(-@size, @size*2)
    vertex(@size, @size*2)
    end_shape

    pop_matrix
  end
end
