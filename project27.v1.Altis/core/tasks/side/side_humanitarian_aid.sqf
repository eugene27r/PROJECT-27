/*
	written by eugene27.
	server only
*/

params ["_taskID","_reward"];

private _taskID = "SIDE_" + str _taskID;

private _pos = [false,false,[],["NameCityCapital","NameCity"]] call prj_fnc_selectCaptPosition;

[_taskID,_pos,"ColorWEST",0.7,[[300,300],"ELLIPSE"]] call prj_fnc_createMarker;

[west, [_taskID], ["STR_SIDE_HUMANITARIAN_AID_DESCRIPTION", "STR_SIDE_HUMANITARIAN_AID_TITLE", ""], _pos, "CREATED", 0, true, "container"] call BIS_fnc_taskCreate;

private _box = "C_IDAP_supplyCrate_F" createVehicle ((position spawn_zone) findEmptyPosition [0,100,"C_IDAP_supplyCrate_F"]);
_box setVariable ["ace_cookoff_enable", false, true];
[_box, true, [0, 1.4, 0], 90] call ace_dragging_fnc_setDraggable;
[west, [(_taskID + "_box"),_taskID], ["", "STR_SIDE_HUMANITARIAN_AID_CARGO", ""], _box, "CREATED", 0, false, "box"] call BIS_fnc_taskCreate;

waitUntil {uiSleep 5; !alive _box || ((_box distance _pos < 300) && ((getPosATL _box) select 2) < 0.2 && (speed _box == 0)) || _taskID call BIS_fnc_taskCompleted};

if (!alive _box) then {
    [_taskID,"FAILED"] call BIS_fnc_taskSetState;
    uiSleep 2;
};

if (alive _box && (_box distance _pos < 300) && ((getPosATL _box) select 2) < 0.3 && (speed _box < 1)) then {
    [_taskID,"SUCCEEDED"] call BIS_fnc_taskSetState;
    ["missionNamespace", "money", 0, _reward] call prj_fnc_changePlayerVariableGlobal;
    uiSleep 2;
};

[_taskID] call BIS_fnc_deleteTask;
deleteMarker _taskID;

uiSleep 30;

deleteVehicle _box;