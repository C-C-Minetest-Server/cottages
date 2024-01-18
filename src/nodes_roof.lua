-- cottages/src/nodes_roof.lua
-- Handle roofs
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

cottages.register_roof = function(name, display_name, tiles, basic_material, homedecor_alternative)
    minetest.register_node("cottages:roof_" .. name, {
        description = S("@1 Roof", display_name),
        drawtype = "nodebox",
        tiles = tiles,
        paramtype = "light",
        paramtype2 = "facedir",
        groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
        node_box = {
            type = "fixed",
            fixed = {
                { -0.5, -0.5, -0.5, 0.5, 0,   0 },
                { -0.5, 0,    0,    0.5, 0.5, 0.5 },
            },
        },
        selection_box = {
            type = "fixed",
            fixed = {
                { -0.5, -0.5, -0.5, 0.5, 0,   0 },
                { -0.5, 0,    0,    0.5, 0.5, 0.5 },
            },
        },
        is_ground_content = false,
    })

    -- a better roof than the normal stairs; this one is for usage directly on top of walls (it has the form of a stair)
    if name ~= "straw" or not minetest.registered_nodes["stairs:stair_straw"] then
        minetest.register_node("cottages:roof_connector_" .. name, {
            description = S("@1 Roof connector", display_name),
            drawtype = "nodebox",
            -- top, bottom, side1, side2, inner, outer
            tiles = tiles,
            paramtype = "light",
            paramtype2 = "facedir",
            groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
            node_box = {
                type = "fixed",
                fixed = {
                    { -0.5, -0.5, -0.5, 0.5, 0,   0.5 },
                    { -0.5, 0,    0,    0.5, 0.5, 0.5 },
                },
            },
            selection_box = {
                type = "fixed",
                fixed = {
                    { -0.5, -0.5, -0.5, 0.5, 0,   0.5 },
                    { -0.5, 0,    0,    0.5, 0.5, 0.5 },
                },
            },
            is_ground_content = false,
        })
    else
        minetest.register_alias("cottages:roof_connector_straw", "stairs:stair_straw")
    end

    -- this one is the slab version of the above roof
    if name ~= "straw" or not minetest.registered_nodes["stairs:slab_straw"] then
        minetest.register_node("cottages:roof_flat_" .. name, {
            description = S("@1 Roof (flat) ", display_name),
            drawtype = "nodebox",
            -- top, bottom, side1, side2, inner, outer
            -- this one is from all sides - except from the underside - of the given material
            tiles = { tiles[1], tiles[2], tiles[1], tiles[1], tiles[1], tiles[1] },
            paramtype = "light",
            paramtype2 = "facedir",
            groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
            node_box = {
                type = "fixed",
                fixed = {
                    { -0.5, -0.5, -0.5, 0.5, 0, 0.5 },
                },
            },
            selection_box = {
                type = "fixed",
                fixed = {
                    { -0.5, -0.5, -0.5, 0.5, 0, 0.5 },
                },
            },
            is_ground_content = false,
        })
    else
        minetest.register_alias("cottages:roof_flat_straw", "stairs:slab_straw")
    end

    local output = "cottages_roof_" .. name
    if not homedecor_alternative or minetest.get_modpath("homedecor") then
        minetest.register_craft({
            output = "cottages:roof_" .. name .. " 6",
            recipe = {
                { '',             '',             basic_material },
                { '',             basic_material, '' },
                { basic_material, '',             '' }
            }
        })
    elseif homedecor_alternative then
        basic_material = 'cottages:roof_wood'

        minetest.register_craft({
            output = "cottages:roof_" .. name .. " 3",
            recipe = {
                { homedecor_alternative, '',             basic_material },
                { '',                    basic_material, '' },
                { basic_material,        '',             '' }
            }
        })
    end

    minetest.register_craft({
        output = "cottages:roof_connector_" .. name,
        recipe = {
            { 'cottages:roof_' .. name },
            { "group:wood" },
        }
    })

    minetest.register_craft({
        output = "cottages:roof_flat_" .. name .. ' 2',
        recipe = {
            { 'cottages:roof_' .. name, 'cottages:roof_' .. name },
        }
    })

    -- convert flat roofs back to normal roofs
    minetest.register_craft({
        type = "shapeless",
        output = "cottages:roof_" .. name,
        recipe = {
            "cottages:roof_flat_" .. name,
            "cottages:roof_flat_" .. name
        }
    })
end

cottages.register_roof('straw', S("Straw"),
    { "cottages_darkage_straw.png", "cottages_darkage_straw.png",
        "cottages_darkage_straw.png", "cottages_darkage_straw.png",
        "cottages_darkage_straw.png", "cottages_darkage_straw.png" },
    'cottages:straw_mat', nil)
cottages.register_roof('reet', S("Reet"),
    { "cottages_reet.png", "cottages_reet.png",
        "cottages_reet.png", "cottages_reet.png",
        "cottages_reet.png", "cottages_reet.png" },
    "default:papyrus", nil)
cottages.register_roof('wood', S("Wooden"),
    { "default_tree.png", "default_wood.png",
        "default_wood.png", "default_wood.png",
        "default_wood.png", "default_tree.png" },
    "group:wood", nil)
cottages.register_roof('black', S("Black"),
    { "cottages_homedecor_shingles_asphalt.png", "default_wood.png",
        "default_wood.png", "default_wood.png",
        "default_wood.png", "cottages_homedecor_shingles_asphalt.png" },
    'homedecor:shingles_asphalt', "default:coal_lump")
cottages.register_roof('red', S("Red"),
    { "cottages_homedecor_shingles_terracotta.png", "default_wood.png",
        "default_wood.png", "default_wood.png",
        "default_wood.png", "cottages_homedecor_shingles_terracotta.png" },
    'homedecor:shingles_terracotta', "default:clay_brick")
cottages.register_roof('brown', S("Brown"),
    { "cottages_homedecor_shingles_wood.png", "default_wood.png",
        "default_wood.png", "default_wood.png",
        "default_wood.png", "cottages_homedecor_shingles_wood.png" },
    'homedecor:shingles_wood', "default:dirt")
cottages.register_roof('slate', S("Slate"),
    { "cottages_slate.png", "default_wood.png",
        "cottages_slate.png", "cottages_slate.png",
        "default_wood.png", "cottages_slate.png" },
    "default:stone", nil)

---------------------------------------------------------------------------------------
-- slate roofs are sometimes on vertical fronts of houses
---------------------------------------------------------------------------------------
minetest.register_node("cottages:slate_vertical", {
    description = S("Vertical Slate"),
    tiles = { "cottages_slate.png", cottages.texture_roof_sides, "cottages_slate.png", "cottages_slate.png", cottages.texture_roof_sides, "cottages_slate.png" },
    paramtype2 = "facedir",
    groups = { cracky = 2, stone = 1 },
    sounds = default.node_sound_stone_defaults(),
    is_ground_content = false,
})


minetest.register_craft({
    output = "cottages:slate_vertical",
    recipe = {
        { "default:stone", "default_wood.png" }
    }
})

---------------------------------------------------------------------------------------
-- Reed might also be needed as a full block
---------------------------------------------------------------------------------------
minetest.register_node("cottages:reet", {
    description = S("Reet for thatching"),
    tiles = { "cottages_reet.png" },
    groups = { hay = 3, snappy = 3, choppy = 3, oddly_breakable_by_hand = 3, flammable = 3 },
    sounds = default.node_sound_leaves_defaults(),
    is_ground_content = false,
})


minetest.register_craft({
    output = "cottages:reet",
    recipe = {
        { "default:papyrus", "default:papyrus" },
        { "default:papyrus", "default:papyrus" },
    },
})
