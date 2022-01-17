
// This file is an automatically generated and should not be edited

'use strict';

const options = [{"name":"data","type":"Data"},{"name":"sentiment_data","type":"Variables","suggested":["nominal"],"permitted":["factor"]},{"name":"split_var","type":"Variable","suggested":["nominal","ordinal"],"permitted":["factor"]},{"name":"chart_type","type":"List","options":[{"title":"Default bars","name":"dodge"},{"title":"Stacked bars","name":"stack"}],"default":"dodge"},{"name":"uncombine","title":"Uncombine","type":"Bool","default":false},{"name":"switch","title":"Switch splitting roles","type":"Bool","default":false},{"name":"disp_by_perc","title":"Percentage scale","type":"Bool","default":false},{"name":"horizontal_bars","title":"Horizontal bars","type":"Bool","default":false},{"name":"palette_colors","type":"List","title":"Palette","options":[{"name":"YlOrRd","title":"Hot"},{"name":"YlOrBr","title":"Cozy"},{"name":"YlGnBu","title":"Warm ocean"},{"name":"YlGn","title":"Meadows"},{"name":"Reds","title":"Reds"},{"name":"RdPu","title":"Fandango"},{"name":"Purples","title":"Eggplant"},{"name":"PuRd","title":"Purple Reds"},{"name":"PuBuGn","title":"Pearl"},{"name":"PuBu","title":"Sky"},{"name":"OrRd","title":"Warm"},{"name":"Oranges","title":"Canyon"},{"name":"Greys","title":"Limbo"},{"name":"Greens","title":"Leaf"},{"name":"GnBu","title":"Cyan"},{"name":"BuPu","title":"Violets"},{"name":"BuGn","title":"Rainforest"},{"name":"Blues","title":"Deep ocean"},{"name":"Spectral","title":"Spectral"},{"name":"RdYlGn","title":"Parrot"},{"name":"RdYlBu","title":"Nautical"}],"default":"RdYlBu"},{"name":"value_labels","title":"Value labels","type":"Bool","default":false},{"name":"enable_component_axis","title":"Component axis title","type":"Bool","default":true},{"name":"component_axis","title":"Title","type":"String","default":"Survey items"},{"name":"custom_img_size","title":"Custom","type":"Bool","default":false},{"name":"custom_width","title":"Width","type":"Integer","default":550},{"name":"custom_height","title":"Height","type":"Integer","default":400},{"name":"drop","title":"Drop tokens","type":"String","default":""},{"name":"include_anger","title":"Anger","type":"Bool","default":true},{"name":"include_anticipation","title":"Anticipation","type":"Bool","default":true},{"name":"include_disgust","title":"Disgust","type":"Bool","default":true},{"name":"include_fear","title":"Fear","type":"Bool","default":true},{"name":"include_joy","title":"Joy","type":"Bool","default":true},{"name":"include_sadness","title":"Sadness","type":"Bool","default":true},{"name":"include_surprise","title":"Surprise","type":"Bool","default":true},{"name":"include_trust","title":"Trust","type":"Bool","default":true},{"name":"relative_percentages","title":"Relative percentages","type":"Bool","default":false}];

const view = function() {
    
    this.handlers = require('./emotiondetection')

    View.extend({
        jus: "3.0",

        events: [

	]

    }).call(this);
}

view.layout = ui.extend({

    label: "Emotion Detection",
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
					label: "Sentiment Data",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "sentiment_data",
							isTarget: true
						}
					]
				},
				{
					type: DefaultControls.TargetLayoutBox,
					typeName: 'TargetLayoutBox',
					label: "Splitting Variable",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "split_var",
							maxItemCount: 1,
							isTarget: true
						}
					]
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
							label: "Chart Type",
							controls: [
								{
									type: DefaultControls.RadioButton,
									typeName: 'RadioButton',
									name: "default_bars",
									optionName: "chart_type",
									optionPart: "dodge"
								},
								{
									type: DefaultControls.RadioButton,
									typeName: 'RadioButton',
									name: "stacked_bars",
									optionName: "chart_type",
									optionPart: "stack"
								}
							]
						},
						{
							type: DefaultControls.Label,
							typeName: 'Label',
							label: "Data Format",
							controls: [
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "uncombine"
								},
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "switch"
								}
							]
						},
						{
							type: DefaultControls.Label,
							typeName: 'Label',
							label: "Axis Options",
							controls: [
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "disp_by_perc"
								},
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "horizontal_bars"
								}
							]
						},
						{
							type: DefaultControls.Label,
							typeName: 'Label',
							label: "Include",
							controls: [
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "include_anger"
								},
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "include_anticipation"
								},
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "include_disgust"
								},
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "include_fear"
								},
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "include_joy"
								},
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "include_sadness"
								},
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "include_surprise"
								},
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "include_trust"
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
							label: "Labels",
							controls: [
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "value_labels"
								},
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "enable_component_axis",
									controls: [
										{
											type: DefaultControls.TextBox,
											typeName: 'TextBox',
											name: "component_axis",
											format: FormatDef.string
										}
									]
								}
							]
						},
						{
							type: DefaultControls.Label,
							typeName: 'Label',
							label: "Colors",
							controls: [
								{
									type: DefaultControls.ComboBox,
									typeName: 'ComboBox',
									name: "palette_colors"
								}
							]
						},
						{
							type: DefaultControls.Label,
							typeName: 'Label',
							label: "Image Size",
							controls: [
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "custom_img_size"
								},
								{
									type: DefaultControls.TextBox,
									typeName: 'TextBox',
									name: "custom_width",
									suffix: "px",
									format: FormatDef.number
								},
								{
									type: DefaultControls.TextBox,
									typeName: 'TextBox',
									name: "custom_height",
									suffix: "px",
									format: FormatDef.number
								}
							]
						},
						{
							type: DefaultControls.Label,
							typeName: 'Label',
							label: "Percentage Scale Options",
							controls: [
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "relative_percentages"
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
			label: "Advanced",
			collapsed: true,
			controls: [
				{
					type: DefaultControls.LayoutBox,
					typeName: 'LayoutBox',
					margin: "large",
					stretchFactor: 1,
					controls: [
						{
							type: DefaultControls.Label,
							typeName: 'Label',
							label: "Lexicon Modifications",
							controls: [
								{
									type: DefaultControls.TextBox,
									typeName: 'TextBox',
									name: "drop",
									format: FormatDef.string
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
