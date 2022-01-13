
// This file is an automatically generated and should not be edited

'use strict';

const options = [{"name":"data","type":"Data"},{"name":"vars","title":"Survey items","type":"Variables","suggested":["ordinal","nominal"],"permitted":["factor"]},{"name":"group","title":"Split by","type":"Variable","suggested":["ordinal","nominal"],"permitted":["factor"]},{"name":"type","type":"List","options":[{"title":"Pie chart","name":"pie"},{"title":"Doughnut chart","name":"doughnut"}],"default":"pie"},{"name":"explode","title":"Explode","type":"Bool","default":false},{"name":"expvalues","title":"Values, separated by comma","type":"String"},{"name":"showtitle","title":"Title","type":"Bool","default":true},{"name":"showlabels","title":"Labels","type":"Bool","default":false},{"name":"labeltype","type":"List","options":[{"title":"Percentages","name":"percentage"},{"title":"Counts","name":"frequency"}],"default":"percentage"},{"name":"invertcolors","title":"Invert colors","type":"Bool","default":false},{"name":"showlegend","title":"Legend","type":"Bool","default":true},{"name":"palcolor","title":"Palette","type":"List","options":[{"name":"YlOrRd","title":"Hot"},{"name":"YlOrBr","title":"Cozy"},{"name":"YlGnBu","title":"Warm ocean"},{"name":"YlGn","title":"Meadows"},{"name":"Reds","title":"Reds"},{"name":"RdPu","title":"Fandango"},{"name":"Purples","title":"Eggplant"},{"name":"PuRd","title":"Purple Reds"},{"name":"PuBuGn","title":"Pearl"},{"name":"PuBu","title":"Sky"},{"name":"OrRd","title":"Warm"},{"name":"Oranges","title":"Canyon"},{"name":"Greys","title":"Limbo"},{"name":"Greens","title":"Leaf"},{"name":"GnBu","title":"Cyan"},{"name":"BuPu","title":"Violets"},{"name":"BuGn","title":"Rainforest"},{"name":"Blues","title":"Deep ocean"},{"name":"Spectral","title":"Spectral"},{"name":"RdYlGn","title":"Tropical"},{"name":"RdYlBu","title":"Nautical"}],"default":"Purples"}];

const view = function() {
    
    this.handlers = { }

    View.extend({
        jus: "3.0",

        events: [

	]

    }).call(this);
}

view.layout = ui.extend({

    label: "Pie Charts",
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
									label: "Coming Soon..",
									controls: [
										{
											type: DefaultControls.RadioButton,
											typeName: 'RadioButton',
											name: "chart_pie",
											optionName: "type",
											optionPart: "pie"
										},
										{
											type: DefaultControls.RadioButton,
											typeName: 'RadioButton',
											name: "chart_doughnut",
											optionName: "type",
											optionPart: "doughnut",
											enable: "(!chart_pie)"
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
									label: " ",
									controls: [
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "explode",
											enable: "(explode)"
										},
										{
											type: DefaultControls.TextBox,
											typeName: 'TextBox',
											name: "expvalues",
											format: FormatDef.string,
											enable: "(explode)"
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
									label: "Show",
									controls: [
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "showtitle"
										},
										{
											type: DefaultControls.CheckBox,
											typeName: 'CheckBox',
											name: "showlabels",
											controls: [
												{
													type: DefaultControls.RadioButton,
													typeName: 'RadioButton',
													name: "disp_perc",
													optionName: "labeltype",
													optionPart: "percentage",
													enable: "(showlabels)"
												},
												{
													type: DefaultControls.RadioButton,
													typeName: 'RadioButton',
													name: "disp_freq",
													optionName: "labeltype",
													optionPart: "frequency",
													enable: "(showlabels)"
												},
												{
													type: DefaultControls.CheckBox,
													typeName: 'CheckBox',
													name: "invertcolors",
													enable: "(showlabels)"
												}
											]
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
									label: "Colors",
									controls: [
										{
											type: DefaultControls.ComboBox,
											typeName: 'ComboBox',
											name: "palcolor"
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
