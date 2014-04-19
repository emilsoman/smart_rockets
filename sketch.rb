require_relative 'rocket'

def setup
  size(1000, 600)
  @rocket = Rocket.new(width/2, height)
  @rocket.velocity = PVector.new(0, -1)
end

def draw
  background(255)
  @rocket.update
end
