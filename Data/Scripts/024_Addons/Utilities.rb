#méthodes utilitaires ajoutées qui étaient éparpillées partout
# on va essayer de les regrouper ici

def getBodyID(species)
  return (species/NB_POKEMON).round
end

def getHeadID(species,bodyId)
  return (species - (bodyId * NB_POKEMON)).round
end