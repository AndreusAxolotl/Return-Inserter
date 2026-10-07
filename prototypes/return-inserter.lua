require ("util")
require("__base__/prototypes/entity/pipecovers")
require ("circuit-connector-sprites")
local assembler_pictures = require("__base__.prototypes.entity.assembler-pictures")
local pipe_picture = assembler_pictures.assembler3pipepictures
local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")
local movement_triggers = require("__base__/prototypes/entity/movement-triggers")
local cargo_pod_procession_catalogue = require("__base__/prototypes/entity/cargo-pod-catalogue")
local space_age_sounds = require("__space-age__.prototypes.entity.sounds")
local item_sounds = require("__base__.prototypes.item_sounds")
local space_age_item_sounds = require("__space-age__.prototypes.item_sounds")
local item_tints = require("__base__.prototypes.item-tints")
local item_effects = require("__space-age__.prototypes.item-effects")
local meld = require("meld")
local simulations = require("__space-age__.prototypes.factoriopedia-simulations")
local math3d = require "math3d"
local fireutil = require("__base__.prototypes.fire-util")

function make_rotated_animation_variations_from_sheet(variation_count, sheet) --makes remnants work with more than 1 variation
  local result = {}

  local function set_y_offset(variation, i)
    local frame_count = variation.frame_count or 1
    local line_length = variation.line_length or frame_count
    if (line_length < 1) then
      line_length = frame_count
    end

    local height_in_frames = math.floor((frame_count * variation.direction_count + line_length - 1) / line_length)
    -- if (height_in_frames ~= 1) then
    --   log("maybe broken sheet: h=" .. height_in_frames .. ", vc=" .. variation_count .. ", " .. variation.filename)
    -- end
    variation.y = variation.height * (i - 1) * height_in_frames
  end

  for i = 1,variation_count do
    local variation = util.table.deepcopy(sheet)

    if variation.layers then
      for _, layer in pairs(variation.layers) do
        set_y_offset(layer, i)
      end
    else
      set_y_offset(variation, i)
    end

    table.insert(result, variation)
  end
 return result
end


data:extend({
{
    type = "item",
    name = "return-inserter",
    icon = "__Return-Inserter__/graphics/icons/return-inserter.png",
    subgroup = "inserter",
    color_hint = { text = "Y" },
    order = "z[return-inserter]",
    inventory_move_sound = item_sounds.inserter_inventory_move,
    pick_sound = item_sounds.inserter_inventory_pickup,
    drop_sound = item_sounds.inserter_inventory_move,
    place_result = "return-inserter",
    stack_size = 50
  },
{
    type = "recipe",
    name = "return-inserter",
    enabled = false,
    energy_required = 1,
    ingredients = {
        {type = "item", name = "inserter",   amount = 1},
        {type = "item", name = "iron-gear-wheel",   amount = 5},
        {type = "item", name = "iron-stick",   amount = 5},
        {type = "item", name = "copper-cable",   amount = 3},
    },
    results = {
        {type = "item", name = "return-inserter", amount = 1}
    },
    allow_productivity = false,
    crafting_categories = {"crafting"},
    auto_recycle = true
},
{
    type = "corpse",
    name = "return-inserter-remnants",
    icon = "__Return-Inserter__/graphics/icons/return-inserter.png",
    hidden_in_factoriopedia = true,
    flags = {"placeable-neutral", "not-on-map"},
    subgroup = "inserter-remnants",
    order = "a-b-a",
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    tile_width = 1,
    tile_height = 1,
    selectable_in_game = false,
    time_before_removed = 60 * 60 * 15, -- 15 minutes
    expires = false,
    final_render_layer = "remnants",
    animation = make_rotated_animation_variations_from_sheet (4,
    {
      filename = "__Return-Inserter__/graphics/entity/return-inserter/remnants/return-inserter-remnants.png",
      line_length = 1,
      width = 134,
      height = 94,
      direction_count = 1,
      shift = util.by_pixel(3.5, -2),
      scale = 0.5
    })
  },
{
    type = "inserter",
    name = "return-inserter",
    icon = "__Return-Inserter__/graphics/icons/return-inserter.png",
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {mining_time = 0.1, result = "inserter"},
    max_health = 200,
    corpse = "return-inserter-remnants",
    dying_explosion = "inserter-explosion",
    uses_inserter_stack_size_bonus = false,
    resistances =
    {
      {
        type = "fire",
        percent = 90
      }
    },
    collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
    selection_box = {{-0.4, -0.35}, {0.4, 0.45}},
    damaged_trigger_effect = hit_effects.entity(),
    energy_per_movement = "7.5kJ",
    energy_per_rotation = "7.5kJ",
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      drain = "0.7kW"
    },
    extension_speed = 0.005,
    rotation_speed = 0.015,
    filter_count = 5,
    icon_draw_specification = {scale = 0.5},
    fast_replaceable_group = "inserter",
    impact_category = "metal",
    open_sound = sounds.inserter_open,
    close_sound = sounds.inserter_close,
    working_sound = sounds.inserter_basic,
    hand_base_picture =
    {
      filename = "__Return-Inserter__/graphics/entity/return-inserter/return-inserter-hand-base.png",
      priority = "extra-high",
      width = 32,
      height = 136,
      scale = 0.25
    },
    hand_closed_picture =
    {
      filename = "__Return-Inserter__/graphics/entity/return-inserter/return-inserter-hand-closed.png",
      priority = "extra-high",
      width = 72,
      height = 164,
      scale = 0.25
    },
    hand_open_picture =
    {
      filename = "__Return-Inserter__/graphics/entity/return-inserter/return-inserter-hand-open.png",
      priority = "extra-high",
      width = 72,
      height = 164,
      scale = 0.25
    },
    hand_base_shadow =
    {
      filename = "__base__/graphics/entity/burner-inserter/burner-inserter-hand-base-shadow.png",
      priority = "extra-high",
      width = 32,
      height = 132,
      scale = 0.25
    },
    hand_closed_shadow =
    {
      filename = "__base__/graphics/entity/burner-inserter/burner-inserter-hand-closed-shadow.png",
      priority = "extra-high",
      width = 72,
      height = 164,
      scale = 0.25
    },
    hand_open_shadow =
    {
      filename = "__base__/graphics/entity/burner-inserter/burner-inserter-hand-open-shadow.png",
      priority = "extra-high",
      width = 72,
      height = 164,
      scale = 0.25
    },
    pickup_position = {0, -1},
    insert_position = {0, -1.2},
    platform_picture =
    {
      sheet =
      {
        filename = "__Return-Inserter__/graphics/entity/return-inserter/return-inserter-platform.png",
        priority = "extra-high",
        width = 105,
        height = 79,
        shift = util.by_pixel(1.5, 7.5-1),
        scale = 0.5
      }
    },
    circuit_connector = circuit_connector_definitions["inserter"],
    circuit_wire_max_distance = inserter_circuit_wire_max_distance,
    default_stack_control_input_signal = inserter_default_stack_control_input_signal
  },
  {
        type = "technology",
        name = "return-inserter",
        icon = "__Return-Inserter__/graphics/technology/return-inserter.png",
        icon_size = 256,
        effects =
        {
          {
            type = "unlock-recipe",
            recipe = "return-inserter"
          },
        },
        prerequisites = {"space-science-pack"},
        unit =
{
count = 500,
ingredients =
{
{"automation-science-pack", 1},
{"logistic-science-pack", 1},
{"chemical-science-pack", 1},
{"utility-science-pack", 1},
{"space-science-pack", 1},
},
time = 30
}
      }
}
)