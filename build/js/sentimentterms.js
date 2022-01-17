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
  split_var_changed: function(ui, event) {
    this.update_ui(ui);
  },
  custom_img_size_changed: function(ui, event) {
    this.update_ui(ui);
  },
  aggregate_mode_changed: function(ui, event) {
    if (this.running) return;
    this.update_ui(ui);
  },
  
  update_ui: function(ui) {
    
    this.running = true;
    ui.view.model.options.beginEdit();
    
    let senti_vars = ui.sentiment_data.value();
    let splitting_var = ui.split_var.value();
    let enable_switch = senti_vars.length > 1 || Boolean(splitting_var);
    
    ui.switch.setPropertyValue('enable', enable_switch);
    if (!enable_switch) ui.switch.setValue(false);
    
    let use_custom_size = ui.custom_img_size.value();
    let switch_val = ui.switch.value();
    
    let enable_modes = (!switch_val && senti_vars.length > 1) || (switch_val && Boolean(splitting_var));
    
    ui.commonalities_mode.setPropertyValue('enable', enable_modes);
    ui.comparison_mode.setPropertyValue('enable', enable_modes);
    ui.custom_width.setPropertyValue('enable', use_custom_size);
    ui.custom_height.setPropertyValue('enable', use_custom_size);
    
    if (!enable_modes) ui.aggregate_mode.setValue(true);
    
    let not_aggregate = ui.analysis_mode.value() != "aggregate";
    let enable_combine = Boolean(splitting_var) && switch_val && not_aggregate;
    
    ui.combine_wordclouds.setPropertyValue('enable', enable_combine);
    if (!enable_combine) ui.combine_wordclouds.setValue(false);
    
    ui.view.model.options.endEdit();
    this.running = false;
    
  }
  
};