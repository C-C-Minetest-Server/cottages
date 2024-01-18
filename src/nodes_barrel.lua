-- cottages/src/nodes_barrel.lua
-- Barrel for filling liquids (TODO) in
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

local function on_construct(pos)
    local meta = minetest.get_meta(pos);
    local percent = math.random(1, 100);  -- TODO: show real filling

    meta:set_string('formspec',
        "size[8,9]" ..
        "image[2.6,2;2,3;default_sandstone.png^[lowpart:" ..
        (100 - percent) .. ":default_desert_stone.png]" .. -- TODO: better images
        "label[2.2,0;" .. S("Pour:") .. "]" ..
        "list[context;input;3,0.5;1,1;]" ..
        "label[5,3.3;" .. S("Fill:") .. "]" ..
        "list[context;output;5,3.8;1,1;]" ..
        "list[current_player;main;0,5;8,4;]");


    meta:set_string('liquid_type', '');  -- which liquid is in the barrel?
    meta:set_int('liquid_level', 0);     -- how much of the liquid is in there?

    local inv = meta:get_inventory()
    inv:set_size("input", 1);    -- to fill in new liquid
    inv:set_size("output", 1);   -- to extract liquid
end

local function can_dig(pos, player)
    local meta = minetest.get_meta(pos)
    local inv  = meta:get_inventory()

    return cottages.check_inventory_empty(inv, {"input", "output"})
end

-- Liquid handling not yet done even on upstream.
-- but at least, lets add protection checking.

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
    if not player:is_player() then return end
    local pname = player:get_player_name()

    if minetest.is_protected(pos, pname) then
        minetest.record_protection_violation(pos, pname)
        return 0
    end

    return -1
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
    if not player:is_player() then return end
    local pname = player:get_player_name()

    if minetest.is_protected(pos, pname) then
        minetest.record_protection_violation(pos, pname)
        return 0
    end

    return count
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
    if not player:is_player() then return end
    local pname = player:get_player_name()

    if minetest.is_protected(pos, pname) then
        minetest.record_protection_violation(pos, pname)
        return 0
    end

    return -1
end

local function on_punch_swap(name)
    return function(pos, node, puncher)
        node.name = name
        node.param2 = 0
        minetest.swap_node(pos, node)
    end
end

local function within3_param2_swap(name)
    return function(pos, node, puncher)
        if node.param2 < 3 then
            node.param2 = node.param2 + 1
        else
            node.param2 = 0
            node.name = name
        end
        minetest.swap_node(pos, node)
    end
end

minetest.register_node("cottages:barrel", {
    description = S("Barrel (Closed)"),
    paramtype = "light",
    drawtype = "mesh",
    mesh = "cottages_barrel_closed.obj",
    tiles = { "cottages_barrel.png" },
    groups = { snappy = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2 },
    is_ground_content = false,

    on_punch = on_punch_swap("cottages:barrel_open"),

    on_construct = on_construct,
    can_dig = can_dig,

    allow_metadata_inventory_put = allow_metadata_inventory_put,
    allow_metadata_inventory_move = allow_metadata_inventory_move,
    allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_node("cottages:barrel_open", {
    description = S("Barrel (Opened)"),
    paramtype = "light",
    drawtype = "mesh",
    mesh = "cottages_barrel.obj",
    tiles = { "cottages_barrel.png" },
    groups = { snappy = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1 },
    is_ground_content = false,
    drop = "cottages:barrel",

    on_punch = on_punch_swap("cottages:barrel_lying"),

    on_construct = on_construct,
    can_dig = can_dig,

    allow_metadata_inventory_put = allow_metadata_inventory_put,
    allow_metadata_inventory_move = allow_metadata_inventory_move,
    allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_node("cottages:barrel_lying", {
    description = S("Barrel (Closed), lying"),
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "mesh",
    mesh = "cottages_barrel_closed_lying.obj",
    tiles = { "cottages_barrel.png" },
    groups = { snappy = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1 },
    is_ground_content = false,
    drop = "cottages:barrel",

    on_punch = within3_param2_swap("cottages:barrel_lying_open"),

    on_construct = on_construct,
    can_dig = can_dig,

    allow_metadata_inventory_put = allow_metadata_inventory_put,
    allow_metadata_inventory_move = allow_metadata_inventory_move,
    allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_node("cottages:barrel_lying_open", {
    description = S("Barrel (Opened), lying"),
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "mesh",
    mesh = "cottages_barrel_lying.obj",
    tiles = { "cottages_barrel.png" },
    groups = { snappy = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1 },
    is_ground_content = false,
    drop = "cottages:barrel",

    on_punch = within3_param2_swap("cottages:barrel"),

    on_construct = on_construct,
    can_dig = can_dig,

    allow_metadata_inventory_put = allow_metadata_inventory_put,
    allow_metadata_inventory_move = allow_metadata_inventory_move,
    allow_metadata_inventory_take = allow_metadata_inventory_take,
})

-- Tub
local tub_node_box = {
    type = "fixed",
    fixed = {
        { -0.5, -0.5, -0.5, 0.5, -0.1, 0.5 },
    }
}

minetest.register_node("cottages:tub", {
    description = S("Tub"),
    paramtype = "light",
    drawtype = "mesh",
    mesh = "cottages_tub.obj",
    tiles = { "cottages_barrel.png" },
    selection_box = tub_node_box,
    collision_box = tub_node_box,
    groups = { tree = 1, snappy = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2 },
    is_ground_content = false,
})

minetest.register_craft({
    output = "cottages:barrel",
    recipe = {
        { "group:wood",          "",           "group:wood" },
        { "default:steel_ingot", "",           "default:steel_ingot" },
        { "group:wood",          "group:wood", "group:wood" },
    },
})

minetest.register_craft({
    output = "cottages:tub 2",
    recipe = {
        { "cottages:barrel" },
    },
})

minetest.register_craft({
    output = "cottages:barrel",
    recipe = {
        { "cottages:tub" },
        { "cottages:tub" },
    },
})




