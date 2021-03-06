/*
	written by eugene27.
	server only
*/

params ["_taskID","_reward"];

private _taskID = "SIDE_" + str _taskID;

private _center_pos = [1,false] call prj_fnc_selectPosition;

private _enemies = [];
private _vehicles = [];
private _pos = [_center_pos, 100, 550, 5, 0] call BIS_fnc_findSafePos;

private _enemy_grp = createGroup [independent, true];

[west, [_taskID], ["STR_SIDE_DESTRUCTION_OF_VEHICLES_DESCRIPTION", "STR_SIDE_DESTRUCTION_OF_VEHICLES_TITLE", ""], _center_pos, "CREATED", 0, true, "destroy"] call BIS_fnc_taskCreate;

[_taskID,_center_pos,"ColorOrange",0.7,[[600,600],"ELLIPSE"]] call prj_fnc_create_marker;

for [{private _i = 0 }, { _i < [3,7] call BIS_fnc_randomInt }, { _i = _i + 1 }] do {
    private _vehicle = (selectRandom (enemy_vehicles_light + enemy_vehicles_heavy)) createVehicle _pos;
    _vehicle setDir (round (random 359));
    _vehicle lock true;
    _vehicles pushBack _vehicle;
    uisleep 0.2;
    _unit = _enemy_grp createUnit [selectRandom enemy_infantry, (position _vehicle) findEmptyPosition [0,30,"C_IDAP_Man_AidWorker_01_F"], [], 0, "NONE"];
    _enemies pushBack _unit;
    uiSleep 0.8;
};

waitUntil {uiSleep 5;{!alive _x} forEach _vehicles || _taskID call BIS_fnc_taskCompleted};

if ({!alive _x} forEach _vehicles) then {
    [_taskID,"SUCCEEDED"] call BIS_fnc_taskSetState;
    ["missionNamespace", "money", 0, _reward] call prj_fnc_changePlayerVariableGlobal;
    uiSleep 2;
};

[_taskID] call BIS_fnc_deleteTask;
{deleteVehicle _x} forEach _vehicles + _enemies;
deleteMarker _taskID;