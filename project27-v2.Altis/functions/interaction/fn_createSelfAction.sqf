/*
    Author: eugene27
    Date: 13.08.2022
    
    Example:
        [] call P27_fnc_createSelfAction
*/


params ["_name", "_title", "_img", "_statement", "_condition", "_parents"];

if !(_img isEqualTo "") then {
    _img = "\A3\ui_f\data\igui\cfg\simpleTasks\types\" + _img + ".paa";
};

private _action = [_name, _title, _img, _statement, _condition] call ace_interact_menu_fnc_createAction;

private _actionPath = ["ACE_SelfActions"];

if (!isNil "_parents") then {
	_actionPath append _parents;
};

[player, 1, _actionPath, _action] call ace_interact_menu_fnc_addActionToObject;