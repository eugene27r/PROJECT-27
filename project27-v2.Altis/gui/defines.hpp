/* Main display IDD & IDC's */
#define MENU_IDD 2900
#define INFANTRY_SLIDER 2901
#define INFANTRY_EDIT 2902
#define GROUND_SLIDER 2911
#define GROUND_EDIT 2912
#define AIR_SLIDER 2921
#define AIR_EDIT 2922
#define OBJECT_SLIDER 2941
#define OBJECT_EDIT 2942
#define DRONE_SLIDER 2951
#define DRONE_EDIT 2952
#define TERRAIN_NONE 2950
#define GUI_GRID_CENTER_WAbs		((safezoneW / safezoneH) min 1.2)
#define GUI_GRID_CENTER_HAbs		(GUI_GRID_CENTER_WAbs / 1.2)
#define GUI_GRID_CENTER_W		(GUI_GRID_CENTER_WAbs / 40)
#define GUI_GRID_CENTER_H		(GUI_GRID_CENTER_HAbs / 25)
#define GUI_GRID_CENTER_X		(safezoneX + (safezoneW - GUI_GRID_CENTER_WAbs)/2)
#define GUI_GRID_CENTER_Y		(safezoneY + (safezoneH - GUI_GRID_CENTER_HAbs)/2)
#define ST_LEFT           0x00
#define ST_MULTI          0x10
#define SEL(ARRAY,INDEX) (ARRAY select INDEX)

/* Save / Load Manager */
#define MANAGER_GROUP 2999
#define SAVELOAD_GROUP 3000
#define SAVES_LIST 3001
#define SLOT_NAME 3002

/* Namespace Macros */
#define SVAR_MNS missionNamespace setVariable 
#define SVAR_UINS uiNamespace setVariable 
#define SVAR_PNS parsingNamespace setVariable 
#define GVAR_MNS missionNamespace getVariable 
#define GVAR_UINS uiNamespace getVariable
#define GVAR_PNS parsingNamespace getVariable

/* Condition Macros */
#define EQUAL(condition1,condition2) condition1 isEqualTo condition2

/* Display Macros */
#define CONTROL(disp,ctrl) ((findDisplay ##disp) displayCtrl ##ctrl)
#define CONTROL_DATA(ctrl) (lbData[ctrl,lbCurSel ctrl])
#define CONTROL_DATAI(ctrl,index) ctrl lbData index

class RscEdit {
	idc = -1;
	type = 2;
	style = 0x00 + 0x40;
	x = 0;
	y = 0;
	h = 0.2;
	w = 1;
	font = "PuristaMedium";
	sizeEx = 0.04;
	autocomplete = "";
	canModify = true; 
	maxChars = 10;
	forceDrawCaret = false;
	colorSelection[] = {0, 1, 0, 0.5};
	colorText[] = {1, 1, 1, 1};
	colorDisabled[] = {1, 0, 0, 1}; 
	colorBackground[] = {0, 0,0, 1};
	align = "center";
};

class RscText {
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	type = 0;
	style = 0;
	shadow = 0;
	valign = "middle";
	colorShadow[] = {0, 0, 0, 0.5};
	font = "PuristaMedium";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	text = "";
	colorText[] = {1, 1, 1, 1};
	colorBackground[] = {0, 0, 0, 0};
	linespacing = 1;
};

class RscTextHQ {
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	type = 0;
	style = 2;
	shadow = 0;
	colorShadow[] = {0, 0, 0, 0.5};
	font = "EtelkaMonospacePro";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	text = "";
	colorText[] = {1, 1, 1, 1.0};
	colorBackground[] = {0, 0, 0, 0};
	linespacing = 1;
};

class RscStructuredText {
	deletable = 0;
	fade = 0;
	access = 0;
	type = 13;
	idc = -1;
	style = 0;
	colorText[] = {1, 1, 1, 1};
	class Attributes {
		font = "EtelkaMonospacePro";
		color = "#ffffff";
		colorLink = "#D09B43";
		align = "left";
		valign = "middle";
		shadow = 1;
	};
	x = 0;
	y = 0;
	h = 0.035;
	w = 0.1;
	text = "";
	sizeEx = 0.025;
	size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	shadow = 1;
};

class RscListbox {
	style = 16;
	idc = -1;
	type = 5;
	w = 0.275;
	h = 0.04;
	font = "RobotoCondensed";
	colorSelect[] = {1, 1, 1, 1};
	colorText[] = {1, 1, 1, 1};
	colorBackground[] = {0.28, 0.28, 0.28, 0.28};
	colorSelect2[] = {1, 1, 1, 1};
	colorSelectBackground[] = {0.95, 0.95, 0.95, 0.5};
	colorSelectBackground2[] = {1, 1, 1, 0.5};
	colorScrollbar[] = {0.2, 0.2, 0.2, 1};
	colorPicture[] = {1, 1, 1, 1};
	colorPictureSelected[] = {1, 1, 1, 1};
	colorPictureDisabled[] = {1, 1, 1, 1};
	arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
	arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
	wholeHeight = 0.45;
	rowHeight = 0.04;
	color[] = {0.7, 0.7, 0.7, 1};
	colorActive[] = {0, 0, 0, 1};
	colorDisabled[] = {0, 0, 0, 0.3};
	sizeEx = 0.035;
	soundSelect[] = {"", 0.1, 1};
	soundExpand[] = {"", 0.1, 1};
	soundCollapse[] = {"", 0.1, 1};
	maxHistoryDelay = 1;
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	tooltipColorText[] = {1, 1, 1, 1};
	tooltipColorBox[] = {1, 1, 1, 1};
	tooltipColorShade[] = {0, 0, 0, 0.65};
	
	class ListScrollBar {
		color[] = {1, 1, 1, 1};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		shadow = 0;
		scrollSpeed = 0.06;
		width = 0;
		height = 0;
		autoScrollEnabled = 1;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
	}
};

class RscPicture {
	deletable = 0;
	fade = 0;
	access = 0;
	type = 0;
	idc = -1;
	style = 48;
	colorBackground[] = {0, 0, 0, 0.5};
	colorText[] = {1, 1, 1, 1};
	font = "TahomaB";
	sizeEx = 0;
	lineSpacing = 0;
	text = "";
	fixedWidth = 0;
	shadow = 0;
	x = 0;
	y = 0;
	w = 0.2;
	h = 0.15;
	tooltipColorText[] = {1, 1, 1, 1};
	tooltipColorBox[] = {1, 1, 1, 1};
	tooltipColorShade[] = {0, 0, 0, 0.65};
};

class RscButton {
	deletable = 0;
	fade = 0;
	access = 0;
	type = 1;
	text = "";
	colorText[] = {1, 1, 1, 1};
	colorDisabled[] = {0,0,0,0,3};
	colorBackground[] = {0,0,0,0.3};
	colorBackgroundDisabled[] = {0,0,0,0.3};
	colorBackgroundActive[] = {0,0.7,0,0.3};
	colorFocused[] = {0,0,0,0.5};
	colorShadow[] = {0,0,0,0.5};
	colorBorder[] = {0,0,0,0.5};
	soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
	soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
	soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
	idc = -1;
	style = 2;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	shadow = 0;
	font = "EtelkaMonospacePro";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	url = "";
	offsetX = 0;
	offsetY = 0;
	offsetPressedX = 0;
	offsetPressedY = 0;
	borderSize = 0;
	class Attributes {
		font = "EtelkaMonospacePro";
		color = "#ffffff";
		align = "center";
		valign = "middle";
		shadow = 0;
	};
};

class RscCombo {
	deletable = 0;
	fade = 0;
	access = 0;
	type = 4;
	colorSelect[] = {0, 0, 0, 1};
	colorText[] = {1, 1, 1, 1};
	colorBackground[] = {0,0, 0, 1};
	colorScrollbar[] = {1, 0, 0, 1};
	colorDisabled[] = {1, 1, 1, 0.25};
	colorPicture[] = {1, 1, 1, 1};
	colorPictureSelected[] = {1, 1, 1, 1};
	colorPictureDisabled[] = {1, 1, 1, 0.25};
	colorPictureRight[] = {1, 1, 1, 1};
	colorPictureRightSelected[] = {1, 1, 1, 1};
	colorPictureRightDisabled[] = {1, 1, 1, 0.25};
	colorTextRight[] = {1, 1, 1, 1};
	colorSelectRight[] = {0, 0, 0, 1};
	colorSelect2Right[] = {0, 0, 0, 1};
	tooltipColorText[] = {1, 1, 1, 1};
	tooltipColorBox[] = {1, 1, 1, 1};
	tooltipColorShade[] = {0, 0, 0, 0.65};
	soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect", 0.1, 1};
	soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand", 0.1, 1};
	soundCollapse[] = {"\A3\ui_f\data\sound\RscCombo\soundCollapse", 0.1, 1};
	maxHistoryDelay = 1;
	class ComboScrollBar {
		color[] = {1, 1, 1, 1};
	};
	style = "0x10 + 0x200";
	font = "RobotoCondensed";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	shadow = 0;
	x = 0;
	y = 0;
	w = 0.12;
	h = 0.035;
	colorSelectBackground[] = {1, 1, 1, 0.7};
	arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa";
	arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
	wholeHeight = 0.45;
	colorActive[] = {1, 0, 0, 1};
};

class RscXSliderH {
	style = 1024;
	type = 43;
	shadow = 2;
	x = 0;
	y = 0;
	h = 0.029412;
	w = 0.400000;
	color[] = {1, 1, 1, 0.7};
	colorActive[] = {1, 1, 1, 1};
	colorDisabled[] = {1, 1, 1, 0.500000};
	arrowEmpty = "\A3\ui_f\data\gui\cfg\slider\arrowEmpty_ca.paa";
	arrowFull = "\A3\ui_f\data\gui\cfg\slider\arrowFull_ca.paa";
	border = "\A3\ui_f\data\gui\cfg\slider\border_ca.paa";
	thumb = "\A3\ui_f\data\gui\cfg\slider\thumb_ca.paa";
};

class IGUIBack {
	type = 0;
	idc = 124;
	style = 128;
	text = "";
	colorText[] = {0, 0, 0, 0};
	font = "RobotoCondensed";
	sizeEx = 0;
	shadow = 0;
	x = 0.1;
	y = 0.1;
	w = 0.1;
	h = 0.1;
	colorbackground[] = {
		"(profilenamespace getvariable ['IGUI_BCG_RGB_R',0])",
		"(profilenamespace getvariable ['IGUI_BCG_RGB_G',1])",
		"(profilenamespace getvariable ['IGUI_BCG_RGB_B',1])",
		"(profilenamespace getvariable ['IGUI_BCG_RGB_A',0.8])"
	};
};