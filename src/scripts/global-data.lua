local global_data = {}

function global_data.init()
  global.flags = {}
  global.players = {}

  global_data.build_prototypes()
end

function global_data.build_prototypes()
  local item_data = {}
  local translation_data = {}
  for name, prototype in pairs(game.item_prototypes) do
    item_data[name] = {
      hidden = prototype.has_flag("hidden"),
      localised_name = prototype.localised_name,
      place_result = prototype.place_result,
      stack_size = prototype.stack_size
    }
    translation_data[#translation_data+1] = {localised=prototype.localised_name, internal=prototype.name}
  end
  global.item_data = item_data
  global.translation_data = translation_data
end

return global_data