module.exports = {
  view_loaded: function(ui, event) {
    updateFunc(ui);
  },
  type_diverging_changed: function(ui, event) {
    updateFunc(ui);
  },
  items_title_changed: function(ui, event) {
    updateFunc(ui);
  },
  format_wide_changed: function(ui, event) {
    updateFunc(ui);
  }
};

let updateFunc = function(ui) {
  let diverging = ui.type_diverging.value();
  let items_title = ui.items_title.value();
  let format_wide = ui.format_wide.value();
  if(diverging) {
    ui.sort.setPropertyValue('enable', true);
  } else {
    ui.sort.setPropertyValue('enable', false);
  };
  if(items_title && format_wide) {
    ui.items_name.setPropertyValue('enable', true);
  } else {
    ui.items_name.setPropertyValue('enable', false);
  }
};