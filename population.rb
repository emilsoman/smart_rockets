require_relative 'rocket'

class Population

  attr_reader :generations

  # Initialize the population
  def initialize(no_of_rockets)
    @no_of_rockets = no_of_rockets
    @population = []
    @mating_pool = []
    @generations = 0
    # Make a new set of rockets
    no_of_rockets.times do
      @population << Rocket.new
    end
  end

  def live(obstacles)
    @population.each do |rocket|
      rocket.check_target
      rocket.live(obstacles)
    end
  end

  # Did anything finish?
  def target_reached?
    @population.each do |rocket|
      return true if rocket.hit_target
    end
    false
  end

  def calculate_fitness
    @population.each do |rocket|
      rocket.calculate_fitness
    end
  end

  # Generate a mating pool
  def prepare_mating_pool
    @mating_pool = []

    # Calculate total fitness of whole population
    max_fitness = get_max_fitness

    # Calculate fitness for each member of the population (scaled to value between 0 and 1)
    # Based on fitness, each member will get added to the mating pool a certain number of times
    # A higher fitness = more entries to mating pool = more likely to be picked as a parent
    # A lower fitness = fewer entries to mating pool = less likely to be picked as a parent
    @population.each do |rocket|
      normalized_fitness = $app.map(rocket.fitness, 0, max_fitness, 0, 1)
      (normalized_fitness * 100).to_i.times { @mating_pool << rocket }
    end
  end

  # Making the next generation
  def reproduce
    # Refill the population with children from the mating pool
    @population = []
    @no_of_rockets.times do
      # Spin the wheel of fortune to pick two parents
      mom = @mating_pool.sample
      dad = @mating_pool.sample
      @population << dad.mate(mom)
    end
    @generations += 1
  end

  private

    # Find highest fintess for the population
    def get_max_fitness
      fitness = 0
      @population.each do |rocket|
        fitness = rocket.fitness if rocket.fitness > fitness
      end
      fitness
    end
end
