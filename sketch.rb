$lifetime = 300
$mutation_rate = 0.2
$max_force = 0.3
$crossover_strategy = 'random_sample'

require_relative 'population'
require_relative 'obstacle'

load_library :control_panel

def setup
  size(1000, 600)

  control_panel do |c|
    c.slider :speed, 1..100
    c.slider(:mutation_rate, 0..1, $mutation_rate) {|s| $mutation_rate = s}
    c.menu(:gene_crossover_strategy, ['random_sample', 'random_midpoint'], $crossover_strategy) {|m| $crossover_strategy = m }
    c.checkbox(:show_obstacles)
    @panel = c
  end

  @lifecycle = 0
  @recordtime = 1.0/0 #No record time yet, keep it Infinity for now.
  $target = Obstacle.new(width/2-12, 24, 24, 24)

  # Create a population with a mutation rate, and population max
  @population = Population.new(50)

  # Create the obstacle course
end

def draw
  background(255)

  # Draw the start and target locations
  $target.display

  # Set up obstacles
  @obstacles = []
  if @show_obstacles
    @obstacles << Obstacle.new(width/2-100, height/2, 200, 10)
  end

  @speed.to_i.times do
    tick
  end

  # Draw the obstacles
  @obstacles.each do |x|
    x.display()
  end

  # Display some info
  fill(0)
  text("Generation #: #{@population.generations}", 10, 18)
  text("Moves left: #{ $lifetime - @lifecycle }", 10, 36)
  text("Record moves: #{ @recordtime }", 10, 54)

  # Show control panel
  @panel.set_visible true
end

def tick
  # If the generation hasn't ended yet
  if (@lifecycle < $lifetime)
    @population.live(@obstacles)
    if (@population.target_reached? && (@lifecycle < @recordtime))
      @recordtime = @lifecycle
    end
    @lifecycle += 1
  # Otherwise a new generation
  else
    @lifecycle = 0
    @population.calculate_fitness
    @population.prepare_mating_pool
    @population.reproduce
  end
end


# Move the target if the mouse is pressed
# System will adapt to new target
def mousePressed
  $target.location.x = mouseX
  $target.location.y = mouseY
  @recordtime = 1.0/0
end
