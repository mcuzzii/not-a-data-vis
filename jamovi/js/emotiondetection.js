module.exports = {
  
  running: false,
  
  view_updated: function(ui, event) {
    this.update_ui(ui);
  },
  sentiment_data_changed: function(ui, event) {
    this.update_ui(ui);
  },
  switch_changed: function(ui, event) {
    if (this.running) return;
    this.update_ui(ui);
  },
  enable_component_axis_changed: function(ui, event) {
    if (this.running) return;
    this.update_ui(ui);
  },
  split_var_changed: function(ui, event) {
    this.update_ui(ui);
  },
  uncombine_changed: function(ui, event) {
    if (this.running) return;
    this.update_ui(ui);
  },
  custom_img_size_changed: function(ui, event) {
    this.update_ui(ui);
  },
  
  update_ui: function(ui) {
    
    this.running = true;
    ui.view.model.options.beginEdit();
    
    let senti_vars = ui.sentiment_data.value();
    
    ui.uncombine.setPropertyValue('enable', senti_vars.length > 1);
    if (!ui.uncombine.getPropertyValue('enable')) ui.uncombine.setValue(false);
    
    let uncombine_val = ui.uncombine.value();
    let splitting_var = Boolean(ui.split_var.value());
    
    ui.switch.setPropertyValue('enable', uncombine_val || splitting_var);
    if (!ui.switch.getPropertyValue('enable')) ui.switch.setValue(false);
    
    let switch_val = ui.switch.value();
    let custom_named = uncombine_val && (!(splitting_var || switch_val) || (splitting_var && switch_val));
    let split_var_title = splitting_var && !switch_val;
    
    ui.enable_component_axis.setPropertyValue('enable', custom_named);
    if (!custom_named) ui.enable_component_axis.setValue(split_var_title);
    
    let custom_name_shown = ui.enable_component_axis.value();
    
    ui.component_axis.setPropertyValue('enable', custom_name_shown);
    
    let custom_img_size_used = ui.custom_img_size.value();
    
    ui.custom_width.setPropertyValue('enable', custom_img_size_used);
    ui.custom_height.setPropertyValue('enable', custom_img_size_used);
    
    ui.view.model.options.endEdit();
    this.running = false;
    
  }
  
};