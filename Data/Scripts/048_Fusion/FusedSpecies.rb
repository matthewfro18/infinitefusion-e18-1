module GameData
  class FusedSpecies < GameData::Species
    attr_reader :growth_rate

    def initialize(id)
      if id.is_a?(Integer)
        body_id = getBodyID(id)
        head_id = getHeadID(id,body_id)
        pokemon_id = getFusedPokemonIdFromDexNum(body_id,head_id)
        return GameData::FusedSpecies.new(pokemon_id)
      end
      head_id = get_head_id_from_symbol(id)
      body_id = get_body_id_from_symbol(id)

      @body_pokemon = GameData::Species.get(head_id)
      @head_pokemon = GameData::Species.get(body_id)

      @id = id
      @id_number = calculate_dex_number()
      @species = @id
      @form = 0
      @real_name = calculate_name() #todo
      @real_form_name = nil
      @real_category = "???" #todo
      @real_pokedex_entry = calculate_dex_entry() #todo
      @pokedex_form = @form
      #todo type exceptions
      @type1 = @head_pokemon.type1
      @type2 = @body_pokemon.type2

      #Stats
      @base_stats = calculate_base_stats()
      @evs = calculate_evs() #todo
      adjust_stats_with_evs()

      @base_exp = calculate_base_exp()
      @growth_rate = calculate_growth_rate() #todo
      @gender_ratio = calculate_gender() #todo
      @catch_rate = calculate_catch_rate()
      @happiness = calculate_base_happiness()
      @moves = calculate_moveset()

      #todo : all below
      @tutor_moves = [] # hash[:tutor_moves] || []
      @egg_moves = [] # hash[:egg_moves] || []
      @abilities = [] # hash[:abilities] || []
      @hidden_abilities = [] # hash[:hidden_abilities] || []
      @wild_item_common = [] # hash[:wild_item_common]
      @wild_item_uncommon = [] # hash[:wild_item_uncommon]
      @wild_item_rare = [] #  hash[:wild_item_rare]
      @egg_groups = [:Undiscovered] # hash[:egg_groups] || [:Undiscovered]
      @hatch_steps = 1 #  hash[:hatch_steps] || 1
      @incense = nil #hash[:incense]
      @evolutions = [] # hash[:evolutions] || []
      @height = 1 # hash[:height] || 1
      @weight = 1 #hash[:weight] || 1
      @color = :Red #hash[:color] || :Red
      @shape = :Head #hash[:shape] || :Head
      @habitat = :None #hash[:habitat] || :None
      @generation = 0 #hash[:generation] || 0
      @mega_stone = nil
      @mega_move = nil
      @unmega_form = 0
      @mega_message = 0
      @back_sprite_x = 0 # hash[:back_sprite_x] || 0
      @back_sprite_y = 0 # hash[:back_sprite_y] || 0
      @front_sprite_x = 0 # hash[:front_sprite_x] || 0
      @front_sprite_y = 0 #  hash[:front_sprite_y] || 0
      @front_sprite_altitude = 0 # hash[:front_sprite_altitude] || 0
      @shadow_x = 0 # hash[:shadow_x] || 0
      @shadow_size = 2 # hash[:shadow_size] || 2
      @alwaysUseGeneratedSprite = false
    end

    def get_body_id_from_symbol(id)
      return id.to_s.match(/\d+/)[0].to_i
    end

    def get_head_id_from_symbol(id)
      return id.to_s.match(/(?<=H)\d+/)[0].to_i
    end

    def adjust_stats_with_evs
      GameData::Stat.each_main do |s|
        @base_stats[s.id] = 1 if !@base_stats[s.id] || @base_stats[s.id] <= 0
        @evs[s.id] = 0 if !@evs[s.id] || @evs[s.id] < 0
      end
    end

    #FUSION CALCULATIONS

    def calculate_dex_number()
      return (@head_pokemon.id_number * NB_POKEMON) + @body_pokemon.id_number
    end

    def calculate_base_stats()
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

    def calculate_base_exp()
      head_exp = @head_pokemon.base_exp
      body_exp = @body_pokemon.base_exp
      return average_values(head_exp, body_exp)
    end

    def calculate_catch_rate
      return get_lowest_value(@body_pokemon.catch_rate, @head_pokemon.catch_rate)
    end

    def calculate_base_happiness
      return @head_pokemon.happiness
    end

    def calculate_moveset
      return combine_arrays(@body_pokemon.moves, @head_pokemon.moves)
    end

    #todo
    def calculate_name()
      return @body_pokemon.name + "/" + @head_pokemon.name
    end

    #todo
    def calculate_evs()
      return {}
    end

    #todo
    def calculate_growth_rate
      return :Medium
    end

    #todo
    def calculate_dex_entry
      return "this is a fused pokemon bro"
    end

    #todo
    def calculate_gender
      return :Genderless
    end

    #UTILS
    #
    def calculate_fused_stats(dominantStat, otherStat)
      return ((2 * dominantStat) / 3) + (otherStat / 3).floor
    end

    def average_values(value1, value2)
      return ((value1 + value2) / 2).floor
    end

    def average_map_values(map1, map2)
      averaged_map = map1.merge(map2) do |key, value1, value2|
        ((value1 + value2) / 2.0).floor
      end
      return averaged_map
    end

    def get_highest_value(value1, value2)
      return value1 > value2 ? value1 : value2
    end

    def get_lowest_value(value1, value2)
      return value1 < value2 ? value1 : value2
    end

    def combine_arrays(array1, array2)
      return array1 + array2
    end

  end
end
