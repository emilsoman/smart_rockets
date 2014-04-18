require_relative 'dna'

class Rocket
  include Processing::Proxy

  attr_reader :dna, :hit_target, :fitness, :location

  def initialize(dna = nil)
    @acceleration = PVector.new
    @velocity = PVector.new
    @location = PVector.new($app.width/2, $app.height + 20)
    @size = 4
    @dna = dna || Dna.new
    @finish_time = 0
    @record_dist = 1.0/0
    @frame = 0
  end

  def calculate_fitness
    # Reward finishing faster and getting close
    @fitness = (1.0 / (@finish_time * @record_dist))

    # Make the function exponential
    @fitness = fitness ** 4

    @fitness *= 0.1 if @hit_obstacle # lose 90% of fitness hitting an obstacle
    @fitness *= 2 if @hit_target # double the fitness for finishing!
  end

  # Run in relation to all the obstacles
  # If I'm stuck, don't bother updating or checking for intersection
  def live(obstacles)
    unless @hit_obstacle
      unless @hit_target
        gene_index = @frame % @dna.genes.size
        apply_force(@dna.genes[gene_index])
        @frame += 1
        move
        check_if_hit_obstacles(obstacles)
      end
      display
    end
  end

  # Did I make it to the target?
  def check_target
    distance = PVector.dist(@location, $target.location)
    @record_dist = distance if (distance < @record_dist)

    if ($target.contains?(@location) && !@hit_target)
      @hit_target = true
    elsif !@hit_target
      @finish_time += 1
    end
  end

  # Did I hit an obstacle?
  def check_if_hit_obstacles(obstacles)
    obstacles.each do |o|
      @hit_obstacle = true if o.contains?(@location)
    end
  end

  # Produce offspring with another rocket
  def mate(rocket)
    child_dna = dna.crossover(rocket.dna)
    child_dna.mutate($mutation_rate)
    Rocket.new(child_dna)
  end

  def apply_force(force)
    @acceleration.add(force)
  end


  def move
    @velocity.add(@acceleration)
    @location.add(@velocity)

    #Reset acceleration
    @acceleration.mult(0)
  end

  def display
    #background(255,0,0);
    theta = @velocity.heading + PI/2
    fill(200, 100)
    stroke(0)
    stroke_weight(1)
    push_matrix

    translate(@location.x, @location.y)
    rotate(theta)

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
