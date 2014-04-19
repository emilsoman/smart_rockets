def setup
  size(1000, 600)
  @size = 30
  @location = [width/2, height]
end

def draw
  background(255)
  fill(200, 100)
  stroke(0)
  stroke_weight(1)
  push_matrix

  @location[1] -= 1
  translate(@location[0], @location[1])

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
