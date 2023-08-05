class FusedPokemon < Pokemon
  attr_reader :body_pokemon, :head_pokemon

  def initialize(species, level, owner = $Trainer, withMoves = true, recheck_form = true)
    @body_pokemon = GameData::Species.get((getBodyID(species)))
    @head_pokemon = GameData::Species.get((getHeadID(species, @body_pokemon)))

    #default to body for missing values
    super(getBodyID(species), level, owner, withMoves, recheck_form)
  end




  #TODO
  def name
    return @body_pokemon.name + " " + @head_pokemon.name
  end

  #Types
  #Todo: type exceptions
  def type1
    return @head_pokemon.type1
  end

  def type2
    return @body_pokemon.type2
  end

  def baseStats
    head_stats = @head_pokemon.base_stats
    body_stats = @body_pokemon.base_stats

    fused_stats = {}

    #Head dominant stats
    fused_stats[:HP] = calculate_fused_stats(head_stats[:HP], body_stats[:HP])
    fused_stats[:SPECIAL_DEFENSE] = calculate_fused_stats(head_stats[:SPECIAL_DEFENSE], body_stats[:SPECIAL_DEFENSE])
    fused_stats[:SPECIAL_ATTACK] = calculate_fused_stats(head_stats[:SPECIAL_ATTACK], body_stats[:SPECIAL_ATTACK])

    #Body dominant stats
    fused_stats[:ATTACK] = calculate_fused_stats(body_stats[:ATTACK], head_stats[:ATTACK])
    fused_stats[:DEFENSE] = calculate_fused_stats(body_stats[:DEFENSE], head_stats[:DEFENSE])
    fused_stats[:SPEED] = calculate_fused_stats(body_stats[:SPEED], head_stats[:SPEED])

    return fused_stats
  end

  #Always return genderless
  def gender
    @gender = 2
    return @gender
  end

  #todo
  def growth_rate
    super
  end

  def base_exp
    head_exp = @head_pokemon.base_exp
    body_exp = @body_pokemon.base_exp
    return average_values(head_exp, body_exp)
  end

  def evYield
    super
  end

  #Util methods
  def calculate_fused_stats(dominantStat, otherStat)
    return ((2 * dominantStat) / 3) + (otherStat / 3).floor
  end

  def average_values(value1, value2)
    return ((value1 + value2) / 2).floor
  end

  def average_map_values(map1, map2)
    p map1
    p map2

    averaged_map = map1.merge(map2) do |key, value1, value2|
      ((value1 + value2) / 2.0).floor
    end
    p averaged_map
    return averaged_map
  end

end

