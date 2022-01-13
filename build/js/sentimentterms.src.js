
// This file is an automatically generated and should not be edited

'use strict';

const options = [{"name":"data","type":"Data"},{"name":"sentiment_data","type":"Variables","suggested":["nominal"],"permitted":["factor"]},{"name":"split_var","type":"Variable","suggested":["nominal","ordinal"],"permitted":["factor"]},{"name":"sentiment_type","type":"List","options":[{"title":"All","name":"all"},{"title":"Positive (General)","name":"positive"},{"title":"Negative (General)","name":"negative"},{"title":"Anticipation","name":"anticipation"},{"title":"Trust","name":"trust"},{"title":"Joy","name":"joy"},{"title":"Surprise","name":"surprise"},{"title":"Sadness","name":"sadness"},{"title":"Anger","name":"anger"},{"title":"Fear","name":"fear"},{"title":"Disgust","name":"disgust"}],"default":"all"},{"name":"analysis_mode","type":"List","options":[{"title":"Aggregate","name":"aggregate"},{"title":"Commonalities","name":"commonalities"},{"title":"Comparison","name":"comparison"}],"default":"aggregate"},{"name":"switch","title":"Switch splitting roles","type":"Bool","default":false},{"name":"font_family","title":"Font family","type":"List","options":[{"title":"Helvetica","name":"sans"},{"title":"Times","name":"serif"},{"title":"Courier","name":"mono"}],"default":"sans"},{"name":"font_face","title":"Font face","type":"List","options":[{"title":"Normal","name":"normal"},{"title":"Bold","name":"bold"},{"title":"Italics","name":"italics"},{"title":"Bold italics","name":"bold_italics"}],"default":"normal"},{"name":"palette_colors","type":"List","title":"Colors","options":[{"name":"YlOrRd","title":"Hot"},{"name":"YlOrBr","title":"Cozy"},{"name":"YlGnBu","title":"Warm ocean"},{"name":"YlGn","title":"Meadows"},{"name":"Reds","title":"Reds"},{"name":"RdPu","title":"Fandango"},{"name":"Purples","title":"Eggplant"},{"name":"PuRd","title":"Purple Reds"},{"name":"PuBuGn","title":"Pearl"},{"name":"PuBu","title":"Sky"},{"name":"OrRd","title":"Warm"},{"name":"Oranges","title":"Canyon"},{"name":"Greys","title":"Limbo"},{"name":"Greens","title":"Leaf"},{"name":"GnBu","title":"Cyan"},{"name":"BuPu","title":"Violets"},{"name":"BuGn","title":"Rainforest"},{"name":"Blues","title":"Deep ocean"},{"name":"Spectral","title":"Spectral"},{"name":"RdYlGn","title":"Parrot"},{"name":"RdYlBu","title":"Nautical"}],"default":"RdYlBu"},{"name":"scale_percentage","title":"Scale","type":"Integer","min":25,"max":100,"default":100},{"name":"max_words","title":"Maximum words","type":"Integer","min":10,"max":1000,"default":100},{"name":"custom_img_size","type":"Bool","title":"Custom","default":false},{"name":"custom_width","title":"Width","type":"Integer","default":550},{"name":"custom_height","title":"Height","type":"Integer","default":400}];

const view = function() {
    
    this.handlers = require('./sentimentterms')

    View.extend({
        jus: "3.0",

        events: [

	]

    }).call(this);
}

view.layout = ui.extend({

    label: "Sentiment Terms",
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
					label: "Splitting variable",
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
							label: "Sentiment Type",
							controls: [
								{
									type: DefaultControls.ComboBox,
									typeName: 'ComboBox',
									name: "sentiment_type"
								}
							]
						},
						{
							type: DefaultControls.Label,
							typeName: 'Label',
							label: "Display Options",
							controls: [
								{
									type: DefaultControls.CheckBox,
									typeName: 'CheckBox',
									name: "switch"
								},
								{
									type: DefaultControls.ComboBox,
									typeName: 'ComboBox',
									name: "font_family"
								},
								{
									type: DefaultControls.ComboBox,
									typeName: 'ComboBox',
									name: "font_face"
								},
								{
									type: DefaultControls.ComboBox,
									typeName: 'ComboBox',
									name: "palette_colors"
								},
								{
									type: DefaultControls.TextBox,
									typeName: 'TextBox',
									name: "scale_percentage",
									suffix: "%",
									format: FormatDef.number
								},
								{
									type: DefaultControls.TextBox,
									typeName: 'TextBox',
									name: "max_words",
									suffix: "words",
									format: FormatDef.number
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
							label: "Analysis Mode",
							controls: [
								{
									type: DefaultControls.RadioButton,
									typeName: 'RadioButton',
									name: "aggregate_mode",
									optionName: "analysis_mode",
									optionPart: "aggregate"
								},
								{
									type: DefaultControls.RadioButton,
									typeName: 'RadioButton',
									name: "commonalities_mode",
									optionName: "analysis_mode",
									optionPart: "commonalities"
								},
								{
									type: DefaultControls.RadioButton,
									typeName: 'RadioButton',
									name: "comparison_mode",
									optionName: "analysis_mode",
									optionPart: "comparison"
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
						}
					]
				}
			]
		}
	]
});

module.exports = { view : view, options: options };
