class Dna
  include Processing::Proxy

  attr_reader :genes

  # Constructor (makes a DNA of random PVectors)
  def initialize(genes = nil)
    @genes = []
    if genes.nil?
      $lifetime.times do |gene|
        @genes << create_gene_with_random_vector
      end

      # First life off vector gets an extra magnitude
      @genes.first.normalize
    else
      genes.each do |gene|
        @genes << gene.get
      end
    end
  end

  def create_gene_with_random_vector
    angle = $app.random(TWO_PI);
    gene = PVector.new(Math.cos(angle), Math.sin(angle))
    gene.mult($app.random(0, $max_force))
    gene
  end

  # Crossover
  # =========
  # Creates new DNA sequence from self and a partner
  def crossover(other_dna)
    selected_genes = []
    if $crossover_strategy == 'random_midpoint'
      random_midpoint = rand(@genes.size)
      @genes.size.times do |index|
        gene = (index < random_midpoint) ? @genes[index] : other_dna.genes[index]
        selected_genes << gene
      end
    elsif $crossover_strategy == 'random_sample'
      gene_pool = @genes + other_dna.genes
      selected_genes = gene_pool.sample(@genes.size)
    end

    Dna.new(selected_genes)
  end

  # Based on a mutation probability, picks a new random Vector
  def mutate(mutation_rate)
    @genes.map! do |gene|
      rand < mutation_rate ? create_gene_with_random_vector : gene
    end
    @genes.first.normalize
  end

end
