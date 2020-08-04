/*
	written by eugene27.
	server only
*/

params ["_taskID","_reward"];

private _taskID = "SIDE_" + str _taskID;

private _center_pos = [1,false] call prj_fnc_select_position;

private _pos = [_center_pos, 200] call prj_fnc_select_house_position;

private _leader = (createGroup independent) createUnit [selectRandom enemy_leaders, _pos, [], 0, "NONE"];
private _enemy = (createGroup independent) createUnit [selectRandom enemy_infantry, position _leader, [], 0, "NONE"];
{_x setBehaviour "CARELESS"} forEach [_leader,_enemy];

[_taskID + "_blue_base",position spawn_zone_blue,"ColorWEST",0.7,[[50,50],"ELLIPSE"]] call prj_fnc_create_marker;
[_taskID + "_center",_center_pos,"ColorEAST",0.7,[[200,200],"ELLIPSE"]] call prj_fnc_create_marker;

private _picture = getText(configfile >> "CfgVehicles" >> typeOf _leader >> "editorPreview");

[west, [_taskID], [format [localize "STR_SIDE_CAPTURE_LEADER_DESCRIPTION",_picture], "STR_SIDE_CAPTURE_LEADER_TITLE", ""], _center_pos, "CREATED", 0, true, "intel"] call BIS_fnc_taskCreate;

waitUntil {sleep 5; !alive _leader || _leader distance position spawn_zone_blue < 50 || _taskID call BIS_fnc_taskCompleted};

if (!alive _leader) then {
    [_taskID,"FAILED"] call BIS_fnc_taskSetState;
	sleep 2;
};

if (_leader distance position spawn_zone_blue < 50) then {
    [_taskID,"SUCCEEDED"] call BIS_fnc_taskSetState;
	["missionNamespace", getPlayerUID player, "money", 0, _reward] remoteExec ["prj_fnc_changePlayerVariable"];
	sleep 2;
};

[_leader, false] call ACE_captives_fnc_setHandcuffed;
_leader action ["GetOut",vehicle _leader];
[_taskID] call BIS_fnc_deleteTask;
{deleteVehicle _x} forEach [_leader,_enemy];
{deleteMarker _x} forEach [(_taskID + "_red_base"),(_taskID + "_blue_base"),(_taskID + "_center")];