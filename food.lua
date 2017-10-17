items = {}

--[[ Template
items.name = {
  quality = 1,
  properties = {temp = 0, texture = 5, elasticity = 1, density = 10},
  flavor = {salty = 5, sweet = 5, sour = 0, acid = 0},
  cooking = {salty = -0.5, sweet = 0.5, sour = 0, acid = 0},
  methods = {
    fry = {temp = 1, texture = 1, elasticity = 0, density = 0},
    bake = {temp = 1, texture = 0.5, elasticity = 0, density = 0},
    boil = {temp = 1, texture = -0.5, elasticity = -0.2, density = 0},
  },
}
]]--

items.carrot = {
  quality = 1,
  properties = {temp = 0, texture = 5, elasticity = 1, density = 10},
  flavor = {salty = 5, sweet = 5, sour = 0, acid = 0},
  cooking = {salty = -0.5, sweet = 0.5, sour = 0, acid = 0},
  methods = {
    fry = {temp = 1, texture = 1, elasticity = 0, density = 0},
    bake = {temp = 1, texture = 0.5, elasticity = 0, density = 0},
    boil = {temp = 1, texture = -0.5, elasticity = -0.2, density = 0},
  },
}

return items
