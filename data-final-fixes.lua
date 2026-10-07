local function add_tech_prerequisites(tech_name, prerequisites)
  local tech = data.raw.technology[tech_name]
  tech.prerequisites = tech.prerequisites or {}
  for _, prereq in ipairs(tech.prerequisites) do
    if prereq == prerequisites then
      return
    end
  end
  table.insert(tech.prerequisites, prerequisites)
end


local function add_science_pack(tech_name, science_pack)
  local tech = data.raw.technology[tech_name]
  -- If `tech.unit` doesn't exist then it is a trigger tech rather than a science tech, cannot modify it in this way
  if tech.unit then
    tech.unit.ingredients = tech.unit.ingredients or {}
    table.insert(tech.unit.ingredients, science_pack)
  else
    log("Age of Production: Unable to add science to tech `" .. tech_name .. "` due to it being a trigger technology, skipped.")
  end
end

local function is_in_table(table_, value)
  for _, item in pairs(table_) do
    if item == value then
      return true
    end
  end
  return false
end

local function add_crafting_categories(recipe_name, categories)
  local recipe = data.raw.recipe[recipe_name]
  recipe.categories = recipe.categories or {"crafting"}
  for _, category_to_insert in pairs(categories) do
    if not is_in_table(recipe.categories, category_to_insert) then
      table.insert(recipe.categories, category_to_insert)
    end
  end
end

if mods["Paracelsin"] and not mods["Muria"] then
add_science_pack("return-inserter", { "galvanization-science-pack", 1 })
add_tech_prerequisites("return-inserter", "galvanization-science-pack")
add_crafting_categories("return-inserter", {"mechanics"})
data.raw.recipe["return-inserter"].ingredients = {
    {type = "item", name = "inserter",   amount = 1},
        {type = "item", name = "iron-gear-wheel",   amount = 5},
        {type = "item", name = "zinc-rivets",   amount = 5},
        {type = "item", name = "zinc-solder",   amount = 3},
  }
end

if mods["Muria"] and not mods["Paracelsin"] then
    add_science_pack("return-inserter", { "acidworking-science-pack", 1 })
add_tech_prerequisites("return-inserter", "acidworking-science-pack")
data.raw.recipe["return-inserter"].ingredients = {
    {type = "item", name = "inserter",   amount = 1},
        {type = "item", name = "iron-gear-wheel",   amount = 5},
        {type = "item", name = "iron-stick",   amount = 5},
        {type = "item", name = "lead-plate",   amount = 3},
  }
end

if mods["Muria"] and mods["Paracelsin"] then
        add_science_pack("return-inserter", { "acidworking-science-pack", 1 })
add_tech_prerequisites("return-inserter", "acidworking-science-pack")
add_science_pack("return-inserter", { "galvanization-science-pack", 1 })
add_tech_prerequisites("return-inserter", "galvanization-science-pack")
add_crafting_categories("return-inserter", {"mechanics"})
data.raw.recipe["return-inserter"].ingredients = {
    {type = "item", name = "inserter",   amount = 1},
        {type = "item", name = "iron-gear-wheel",   amount = 5},
        {type = "item", name = "zinc-rivets",   amount = 5},
        {type = "item", name = "lead-plate",   amount = 3},
  }
end