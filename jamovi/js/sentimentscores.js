module.exports = {
  
  running: false,
  
  view_updated: function(ui, event) {
    this.update_ui(ui);
  },
  so_3_changed: function(ui, event) {
    this.update_ui(ui);
  },
  sentiment_data_changed: function(ui, event) {
    this.update_ui(ui);
  },
  chart_type_changed: function(ui, event) {
    this.update_ui(ui);
  },
  uncombine_changed: function(ui, event) {
    if (this.running) return;
    this.update_ui(ui);
  },
  split_by_iv_changed: function(ui, event) {
    if (this.running) return;
    this.update_ui(ui);
  },
  iv_changed: function(ui, event) {
    this.update_ui(ui);
  },
  custom_img_size_changed: function(ui, event) {
    this.update_ui(ui);
  },
  
  update_ui: function(ui) {
    
    this.running = true;
    ui.view.model.options.beginEdit();
    
    let eval_sd = ui.sentiment_data.value();
    let eval_so_3 = ui.so_3.value();
    let separable_by_prompt = !eval_so_3 && eval_sd.length > 1;
    ui.uncombine.setPropertyValue('enable', separable_by_prompt);
    if (!separable_by_prompt) ui.uncombine.setValue(false);
    let eval_u = ui.uncombine.value();
    
    let eval_ct = ui.chart_type.value();
    let eval_iv = ui.iv.value();
    let not_scatterplot = eval_ct != "ct_scatterplots";
    let divided = (eval_sd.length > 1 && eval_u) || Boolean(eval_iv);
    ui.split_by_iv.setPropertyValue('enable', not_scatterplot && divided);
    if (!not_scatterplot || !divided) ui.split_by_iv.setValue(false);
    let eval_s = ui.split_by_iv.value();
    
    let eval_so_1 = ui.so_1.value();
    let eval_cis = ui.custom_img_size.value();
    
    let not_density = eval_ct != "ct_density";
    let facet_scatterplot = !not_scatterplot && eval_u;
    let facet_box_density = (Boolean(eval_iv) && !eval_s) || (eval_u && eval_s);
    let enable_facets = (not_scatterplot && facet_box_density) || facet_scatterplot;
    
    ui.so_1.setPropertyValue('enable', not_scatterplot);
    ui.add_graphics.setPropertyValue('enable', not_density);
    ui.facet_mode.setPropertyValue('enable', enable_facets);
    ui.custom_width.setPropertyValue('enable', eval_cis);
    ui.custom_height.setPropertyValue('enable', eval_cis);
    
    if (!ui.so_1.getPropertyValue('enable') && eval_so_1) ui.so_2.setValue(true);
    if (!ui.add_graphics.getPropertyValue('enable')) ui.add_graphics.setValue(false);
    if (!ui.facet_mode.getPropertyValue('enable')) ui.facet_mode.setValue(false);
    
    ui.view.model.options.endEdit();
    this.running = false;
    
  }
  
};