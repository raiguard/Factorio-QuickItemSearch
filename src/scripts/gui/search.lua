local gui = require("__flib__.gui-beta")

local constants = require("constants")

local search = require("scripts.search")

local search_gui = {}

function search_gui.build(player, player_table)
  local refs = gui.build(player.gui.screen, {
    {
      type = "frame",
      direction = "vertical",
      visible = false,
      ref = {"window"},
      actions = {on_closed = "close"},
      children = {
        {type = "flow", ref = {"titlebar", "flow"}, children = {
          {
            type = "label",
            style = "frame_title",
            caption = {"mod-name.QuickItemSearch"},
            ignored_by_interaction = true
          },
          {type = "empty-widget", style = "flib_titlebar_drag_handle", ignored_by_interaction = true},
          {
            type = "sprite-button",
            style = "frame_action_button",
            sprite = "utility/close_white",
            hovered_sprite = "utility/close_black",
            clicked_sprite = "utility/close_black",
            actions = {
              on_click = "close"
            }
          }
        }},
        {
          type = "frame",
          style = "inside_shallow_frame_with_padding",
          style_mods = {top_padding = 9},
          direction = "vertical",
          children = {
            {
              type = "textfield",
              style_mods = {width = 350},
              ref = {"search_textfield"},
              actions = {
                on_confirmed = "enter_result_selection",
                on_text_changed = "update_search_query"
              }
            },
            {type = "frame", style = "deep_frame_in_shallow_frame", style_mods = {top_margin = 10}, children = {
              {type = "scroll-pane", style = "qis_list_box_scroll_pane", style_mods = {height = 28 * 8}, children = {
                {type = "table", style = "qis_list_box_table", column_count = 3, children = {
                  {type = "empty-widget", style_mods = {horizontally_stretchable = true}},
                  {type = "empty-widget"},
                  {type = "empty-widget"},
                  {type = "label", caption = "[item=iron-plate]  Iron plate"},
                  {type = "label", caption = "100 / [color=128, 206, 240]2,318[/color]"},
                  {type = "label", caption = "100 / inf"},
                  {type = "label", caption = "[item=copper-plate]  Copper plate"},
                  {type = "label", caption = "100 / [color=128, 206, 240]15,498[/color]"},
                  {type = "label", caption = "100 / 1500"},
                  {type = "label", caption = "[item=steel-plate]  Steel plate"},
                  {type = "label", caption = "100 / [color=128, 206, 240]62[/color]"},
                  {type = "label", caption = "100 / inf"},
                  {type = "label", caption = "[item=steel-plate]  Steel plate"},
                  {type = "label", caption = "100 / [color=128, 206, 240]62[/color]"},
                  {type = "label", caption = "100 / inf"},
                  {type = "label", caption = "[item=steel-plate]  Steel plate"},
                  {type = "label", caption = "100 / [color=128, 206, 240]62[/color]"},
                  {type = "label", caption = "100 / inf"},
                  {type = "label", caption = "[item=steel-plate]  Steel plate"},
                  {type = "label", caption = "100 / [color=128, 206, 240]62[/color]"},
                  {type = "label", caption = "100 / inf"},
                  {type = "label", caption = "[item=steel-plate]  Steel plate"},
                  {type = "label", caption = "100 / [color=128, 206, 240]62[/color]"},
                  {type = "label", caption = "100 / inf"},
                  {type = "label", caption = "[item=steel-plate]  Steel plate"},
                  {type = "label", caption = "100 / [color=128, 206, 240]62[/color]"},
                  {type = "label", caption = "100 / inf"},
                }},
              }}
            }}
          }
        }
      }
    }
  })

  refs.window.force_auto_center()
  refs.titlebar.flow.drag_target = refs.window

  player_table.guis.search = {
    refs = refs,
    state = {
      mode = "search",
      query = "",
      visible = false
    }
  }
end

function search_gui.destroy(player_table)
  player_table.guis.search.refs.window.destroy()
  player_table.guis.search = nil
end

function search_gui.open(player, player_table)
  local gui_data = player_table.guis.search
  gui_data.refs.window.visible = true
  gui_data.state.visible = true
  player.set_shortcut_toggled("qis-search", true)
  player.opened = gui_data.refs.window

  -- TODO: set state to search
  gui_data.refs.search_textfield.focus()
  gui_data.refs.search_textfield.select_all()
end

function search_gui.close(player, player_table)
  local gui_data = player_table.guis.search
  gui_data.refs.window.visible = false
  gui_data.state.visible = false
  player.set_shortcut_toggled("qis-search", false)
  if player.opened == gui_data.refs.window then
    player.opened = nil
  end
end

function search_gui.toggle(player, player_table)
  local gui_data = player_table.guis.search
  if gui_data.state.visible then
    search_gui.close(player, player_table)
  else
    search_gui.open(player, player_table)
  end
end

function search_gui.handle_action(e, msg)
  local player = game.get_player(e.player_index)
  local player_table = global.players[e.player_index]
  local gui_data = player_table.guis.search
  local refs = gui_data.refs
  local state = gui_data.state

  if msg == "close" then
    search_gui.close(player, player_table)
  elseif msg == "update_search_query" then
    local query = e.text
    for pattern, replacement in pairs(constants.input_sanitizers) do
      query = string.gsub(query, pattern, replacement)
    end
    state.query = query

    if #e.text > 1 then
      search.run(player, player_table, query)
      -- TODO: update results
    else
      -- TODO: clear results
    end
  elseif msg == "enter_result_selection" then
  end
end

return search_gui