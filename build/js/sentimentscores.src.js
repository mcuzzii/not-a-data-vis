
// This file is an automatically generated and should not be edited

'use strict';

const options = [{"name":"data","type":"Data"},{"name":"sentiment_data","type":"Variables","suggested":["nominal"],"permitted":["factor"]},{"name":"iv","type":"Variable","suggested":["nominal","ordinal","continuous"],"permitted":["factor","numeric"]},{"name":"chart_type","type":"List","options":[{"title":"Box plots","name":"ct_boxplots"},{"title":"Density plots","name":"ct_density"},{"title":"Scatterplots","name":"ct_scatterplots"}]},{"name":"scoring_method","type":"List","options":[{"title":"By sentence","name":"by_sentence"},{"title":"By cell","name":"by_cell"},{"title":"By row","name":"by_row"}],"default":"by_sentence"},{"name":"averaging_method","type":"List","options":[{"title":"Default","name":"default_averaging"},{"title":"Courtesy reduction","name":"courtesy_reduction"},{"title":"Neutrality reduction","name":"neutrality_reduction"}],"default":"default_averaging"},{"name":"uncombine","type":"Bool","title":"Uncombine","default":false},{"name":"split_by_iv","type":"Bool","title":"Switch splitting roles","default":false},{"name":"facet_mode","type":"Bool","title":"Facets","default":false},{"name":"add_graphics","type":"Bool","title":"Additional graphics","default":false},{"name":"custom_img_size","type":"Bool","title":"Custom","default":false},{"name":"custom_width","title":"Width","type":"Integer","default":550},{"name":"custom_height","title":"Height","type":"Integer","default":300},{"name":"palette_colors","type":"List","title":"Colors","options":[{"name":"YlOrRd","title":"Hot"},{"name":"YlOrBr","title":"Cozy"},{"name":"YlGnBu","title":"Warm ocean"},{"name":"YlGn","title":"Meadows"},{"name":"Reds","title":"Reds"},{"name":"RdPu","title":"Fandango"},{"name":"Purples","title":"Eggplant"},{"name":"PuRd","title":"Purple Reds"},{"name":"PuBuGn","title":"Pearl"},{"name":"PuBu","title":"Sky"},{"name":"OrRd","title":"Warm"},{"name":"Oranges","title":"Canyon"},{"name":"Greys","title":"Limbo"},{"name":"Greens","title":"Leaf"},{"name":"GnBu","title":"Cyan"},{"name":"BuPu","title":"Violets"},{"name":"BuGn","title":"Rainforest"},{"name":"Blues","title":"Deep ocean"},{"name":"Spectral","title":"Spectral"},{"name":"RdYlGn","title":"Parrot"},{"name":"RdYlBu","title":"Nautical"}]}];

const view = function() {
    
    this.handlers = require('./sentimentscores')

    View.extend({
        jus: "3.0",

        events: [

	]

    }).call(this);
}

view.layout = ui.extend({

    label: "Sentiment Scores",
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
					label: "Sentiment data",
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
					label: "Independent variable",
					controls: [
						{
							type: DefaultControls.VariablesListBox,
							typeName: 'VariablesListBox',
							name: "iv",
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
			label: "Plot Settings",
			collapsed: false,
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
									label: "Chart Type",
									controls: [
										{
											type: DefaultControls.ComboBox,
											typeName: 'ComboBox',
											name: "chart_type"
										}
									]
								},
								{
									type: DefaultControls.Label,
									typeName: 'Label',
									label: "Averaging Method",
									controls: [
										{
											type: DefaultControls.RadioButton,
											typeName: 'RadioButton',
											name: "avem_1",
											optionName: "averaging_method",
											optionPart: "default_averaging"
										},
										{
											type: DefaultControls.RadioButton,
											typeName: 'RadioButton',
											name: "avem_2",
											optionName: "averaging_method",
											optionPart: "courtesy_reduction"
										},
										{
											type: DefaultControls.RadioButton,
											typeName: 'RadioButton',
											name: "avem_3",
											optionName: "averaging_method",
											optionPart: "neutrality_reduction"
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
									label: "Scoring Options",
									controls: [
										{
											type: DefaultControls.RadioButton,
											typeName: 'RadioButton',
											name: "so_1",
											optionName: "scoring_method",
											optionPart: "by_sentence"
										},
										{
											type: DefaultControls.RadioButton,
											typeName: 'RadioButton',
											name: "so_2",
											optionName: "scoring_method",
											optionPart: "by_cell"
										},
										{
											type: DefaultControls.RadioButton,
											typeName: 'RadioButton',
											name: "so_3",
											optionName: "scoring_method",
											optionPart: "by_row"
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
			collapsed: false,
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
									label: "Display Options",
									controls: [
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "uncombine"
										},
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "split_by_iv"
										},
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "facet_mode"
										},
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "add_graphics"
										},
										{
											type: DefaultControls.ComboBox,
											typeName: 'ComboBox',
											name: "palette_colors"
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
