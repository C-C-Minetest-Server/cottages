-- cottages/src/nodes_historic.lua
-- decoration and building material
--[[
    Copyright (C) 2015-2022  Sokomine
	Copyright (C) 2024  1F616EMO

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

local S = cottages.S

minetest.register_node("cottages:wagon_wheel", {
    description = S("Wagon Wheel"),
    drawtype = "signlike",
    tiles = { "cottages_wagonwheel.png" }, -- done by VanessaE!
    inventory_image = "cottages_wagonwheel.png",
    wield_image = "cottages_wagonwheel.png",
    paramtype = "light",
    paramtype2 = "wallmounted",

    sunlight_propagates = true,
    walkable = false,
    selection_box = {
        type = "wallmounted",
    },
    groups = { choppy = 2, dig_immediate = 2, attached_node = 1 },
    legacy_wallmounted = true,
    is_ground_content = false,
})

minetest.register_node("cottages:loam", {
    description = S("Loam"),
    tiles = { "cottages_loam.png" },
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, crumbly = 3 },
    sounds = default.node_sound_dirt_defaults(),
    is_ground_content = false,
})

stairs.register_stair_and_slab("loam", "cottages:loam",
    { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    { "cottages_loam.png" },
    S("Loam Stairs"),
    S("Loam Slab"),
    default.node_sound_dirt_defaults()
)

stairs.register_stair_and_slab("clay", "default:clay",
    { crumbly = 3 },
    { "cottages_clay.png" },
    S("Clay Stairs"),
    S("Clay Slab"),
    default.node_sound_dirt_defaults()
)

minetest.register_node("cottages:straw_ground", {
    description = S("straw ground for animals"),
    tiles = {
        "cottages_darkage_straw.png",
        "cottages_loam.png",
        "cottages_loam.png",
        "cottages_loam.png",
        "cottages_loam.png",
        "cottages_loam.png"
    },
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, crumbly = 3 },
    sounds = default.node_sound_leaves_defaults(),
    is_ground_content = false,
})

minetest.register_node("cottages:glass_pane", {
    description = S("Simple Glass Pane") .. " " .. S("(centered)"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = { "cottages_glass_pane.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    use_texture_alpha = "clip",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    node_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.05, 0.5, 0.5, 0.05 },
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.05, 0.5, 0.5, 0.05 },
        },
    },
    is_ground_content = false,
})

minetest.register_node("cottages:glass_pane_side", {
    description = S("Simple Glass Pane"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = { "cottages_glass_pane.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    use_texture_alpha = "clip",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    node_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.40, 0.5, 0.5, -0.50 },
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.40, 0.5, 0.5, -0.50 },
        },
    },
    is_ground_content = false,
})

-- a very small wooden slab
minetest.register_node("cottages:wood_flat", {
    description = S("Flat Wooden Planks"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    node_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.50, 0.5, -0.5 + 1 / 16, 0.50 },
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.50, 0.5, -0.5 + 1 / 16, 0.50 },
        },
    },
    is_ground_content = false,
    on_place = minetest.rotate_node,
})

minetest.register_node("cottages:wool_tent", {
    description = S("Wool for Tents"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = { "cottages_wool.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    node_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.50, 0.5, -0.5 + 1 / 16, 0.50 },
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.50, 0.5, -0.5 + 1 / 16, 0.50 },
        },
    },
    is_ground_content = false,
    on_place = minetest.rotate_node,
})

minetest.register_alias("cottages:wool", "wool:white")

---------------------------------------------------------------------------------------
-- crafting receipes
---------------------------------------------------------------------------------------
minetest.register_craft({
    output = "cottages:wagon_wheel 3",
    recipe = {
        { "default:iron_lump", "group:stick",         "default:iron_lump" },
        { "group:stick",       "default:steel_ingot", "group:stick" },
        { "default:iron_lump", "group:stick",         "default:iron_lump" }
    }
})

minetest.register_craft({
    output = "cottages:loam 4",
    recipe = {
        { "group:sand" },
        { "default:clay_lump" }
    }
})

minetest.register_craft({
    output = "cottages:straw_ground 2",
    recipe = {
        { "cottages:straw_mat" },
        { "cottages:loam" }
    }
})

minetest.register_craft({
    output = "cottages:glass_pane 4",
    recipe = {
        { "group:stick", "group:stick",   "group:stick" },
        { "group:stick", "default:glass", "group:stick" },
        { "group:stick", "group:stick",   "group:stick" }
    }
})

minetest.register_craft({
    output = "cottages:glass_pane_side",
    recipe = {
        { "cottages:glass_pane" },
    }
})

minetest.register_craft({
    output = "cottages:glass_pane",
    recipe = {
        { "cottages:glass_pane_side" },
    }
})

minetest.register_craft({
    output = "cottages:wood_flat 16",
    recipe = {
        { "group:stick", "farming:string", "group:stick" },
        { "group:stick", "",               "group:stick" },
    }
})

minetest.register_craft({
    output = "cottages:wool_tent 2",
    recipe = {
        { "farming:string", "farming:string" },
        { "",               "group:stick" }
    }
})

minetest.register_craft({
    output = "cottages:wool",
    recipe = {
        { "cottages:wool_tent", "cottages:wool_tent" }
    }
})


