
// This file is an automatically generated and should not be edited

'use strict';

const options = [{"name":"data","type":"Data"},{"name":"vars","type":"Variables","suggested":["ordinal","nominal"],"permitted":["factor"]},{"name":"group","type":"Variable","suggested":["ordinal","nominal"],"permitted":["factor"]},{"name":"format","type":"List","options":[{"title":"Group by response variables","name":"wide"},{"title":"Panel by response variables","name":"long"}],"default":"wide"},{"name":"type","type":"List","options":[{"title":"Default bars","name":"grouped"},{"title":"Stacked bars","name":"stacked"},{"title":"Diverging stacked bars","name":"diverging"}],"default":"grouped"},{"name":"display","title":"Value labels","type":"Bool","default":false},{"name":"percent","title":"Display by %","type":"Bool","default":false},{"name":"flip_axes","title":"Horizontal bars","type":"Bool","default":false},{"name":"sort","title":"Sort","type":"Bool","default":false},{"name":"items_title","title":"Component axis title","type":"Bool","default":true},{"name":"items_name","title":"Title","type":"String","default":"Survey items"},{"name":"freq_title","title":"Frequency axis title","type":"Bool","default":true},{"name":"showlegend","title":"Legend","type":"Bool","default":true},{"name":"palcolor","title":"Palette","type":"List","options":[{"name":"YlOrRd","title":"Hot"},{"name":"YlOrBr","title":"Cozy"},{"name":"YlGnBu","title":"Warm ocean"},{"name":"YlGn","title":"Meadows"},{"name":"Reds","title":"Reds"},{"name":"RdPu","title":"Fandango"},{"name":"Purples","title":"Eggplant"},{"name":"PuRd","title":"Purple Reds"},{"name":"PuBuGn","title":"Pearl"},{"name":"PuBu","title":"Sky"},{"name":"OrRd","title":"Warm"},{"name":"Oranges","title":"Canyon"},{"name":"Greys","title":"Limbo"},{"name":"Greens","title":"Leaf"},{"name":"GnBu","title":"Cyan"},{"name":"BuPu","title":"Violets"},{"name":"BuGn","title":"Rainforest"},{"name":"Blues","title":"Deep ocean"},{"name":"Spectral","title":"Spectral"},{"name":"RdYlGn","title":"Parrot"},{"name":"RdYlBu","title":"Nautical"}],"default":"RdYlBu"},{"name":"imgsizemode","type":"List","options":[{"title":"Auto","name":"automaticsize"},{"title":"Custom","name":"customsize"}],"default":"automaticsize"},{"name":"imgwidth","title":"Width","type":"Integer","default":550},{"name":"imgheight","title":"Height","type":"Integer","default":300}];

const view = function() {
    
    this.handlers = require('./barcharts')

    View.extend({
        jus: "3.0",

        events: [

	]

    }).call(this);
}

view.layout = ui.extend({

    label: "Bar Charts",
    jus: "3.0",
    type: "root",
    stage: 0, //0 - release, 1 - development, 2 - proposed
    controls: [
		{
			type: DefaultControls.VariableSupplier,
			typeName: 'VariableSupplier',
			persistentItems: false,
			stretchFactor: 1,
			controls: [
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "Survey items",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "vars",
							isTarget: true
						}
					]
				},
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "Split by",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "group",
							maxItemCount: 1,
							isTarget: true
						}
					]
				}
			]
		},
		{
			type: DefaultControls.CollapseBox,
			typeName: 'CollapseBox',
			label: "Plot settings",
			collapsed: true,
			controls: [
				{
					type: DefaultControls.Label,
					typeName: 'Label',
					label: "Data Format",
					controls: [
						{
							type: DefaultControls.RadioButton,
							typeName: 'RadioButton',
							name: "format_long",
							optionName: "format",
							optionPart: "long"
						},
						{
							type: DefaultControls.RadioButton,
							typeName: 'RadioButton',
							name: "format_wide",
							optionName: "format",
							optionPart: "wide"
						}
					]
				},
				{
					type: DefaultControls.Label,
					typeName: 'Label',
					label: "Chart Type",
					controls: [
						{
							type: DefaultControls.RadioButton,
							typeName: 'RadioButton',
							name: "type_grouped",
							optionName: "type",
							optionPart: "grouped"
						},
						{
							type: DefaultControls.RadioButton,
							typeName: 'RadioButton',
							name: "type_stacked",
							optionName: "type",
							optionPart: "stacked"
						},
						{
							type: DefaultControls.RadioButton,
							typeName: 'RadioButton',
							name: "type_diverging",
							optionName: "type",
							optionPart: "diverging"
						}
					]
				},
				{
					type: DefaultControls.LayoutBox,
					typeName: 'LayoutBox',
					margin: "large",
					stretchFactor: 1,
					controls: [
						{
							type: DefaultControls.LayoutBox,
							typeName: 'LayoutBox',
							margin: "large",
							cell: {"column":0,"row":0},
							stretchFactor: 1,
							controls: [
								{
									type: DefaultControls.Label,
									typeName: 'Label',
									label: "Axis Options",
									controls: [
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "percent"
										},
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "flip_axes"
										}
									]
								}
							]
						},
						{
							type: DefaultControls.LayoutBox,
							typeName: 'LayoutBox',
							margin: "large",
							cell: {"column":1,"row":0},
							stretchFactor: 1,
							controls: [
								{
									type: DefaultControls.Label,
									typeName: 'Label',
									label: "Diverging Stacked Bars",
									controls: [
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "sort"
										}
									]
								}
							]
						}
					]
				}
			]
		},
		{
			type: DefaultControls.CollapseBox,
			typeName: 'CollapseBox',
			label: "Appearance",
			collapsed: true,
			controls: [
				{
					type: DefaultControls.LayoutBox,
					typeName: 'LayoutBox',
					margin: "large",
					stretchFactor: 1,
					controls: [
						{
							type: DefaultControls.LayoutBox,
							typeName: 'LayoutBox',
							margin: "large",
							cell: {"column":0,"row":0},
							stretchFactor: 1,
							controls: [
								{
									type: DefaultControls.Label,
									typeName: 'Label',
									label: "Colors",
									controls: [
										{
											type: DefaultControls.ComboBox,
											typeName: 'ComboBox',
											name: "palcolor"
										}
									]
								},
								{
									type: DefaultControls.Label,
									typeName: 'Label',
									label: "Show",
									controls: [
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "display"
										},
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "items_title",
											controls: [
												{
													type: DefaultControls.TextBox,
													typeName: 'TextBox',
													name: "items_name",
													format: FormatDef.string
												}
											]
										},
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "freq_title"
										},
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "showlegend"
										}
									]
								}
							]
						},
						{
							type: DefaultControls.LayoutBox,
							typeName: 'LayoutBox',
							margin: "large",
							cell: {"column":1,"row":0},
							stretchFactor: 1,
							controls: [
								{
									type: DefaultControls.Label,
									typeName: 'Label',
									label: "Image Size",
									controls: [
										{
											type: DefaultControls.RadioButton,
											typeName: 'RadioButton',
											name: "sizemodeauto",
											optionName: "imgsizemode",
											optionPart: "automaticsize"
										},
										{
											type: DefaultControls.RadioButton,
											typeName: 'RadioButton',
											name: "sizemodecustom",
											optionName: "imgsizemode",
											optionPart: "customsize"
										},
										{
											type: DefaultControls.TextBox,
											typeName: 'TextBox',
											name: "imgwidth",
											suffix: "px",
											format: FormatDef.number,
											enable: "(sizemodecustom)"
										},
										{
											type: DefaultControls.TextBox,
											typeName: 'TextBox',
											name: "imgheight",
											suffix: "px",
											format: FormatDef.number,
											enable: "(sizemodecustom)"
										}
									]
								}
							]
						}
					]
				}
			]
		}
	]
});

module.exports = { view : view, options: options };
