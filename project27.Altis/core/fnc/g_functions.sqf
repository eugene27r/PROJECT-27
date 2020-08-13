/*
	written by eugene27.
	global functions
*/

prj_fnc_changePlayerVariableLocal = {
	params ["_space","_name","_number", "_value",["_UID",(getPlayerUID player)]];

	private _variable = ((missionNamespace getVariable _UID) select _number) select 1;
	private _player_table = missionNamespace getVariable _UID;
	_player_table set [_number,[_name,_variable + _value]];
	(call (compile _space)) setVariable [_UID, _player_table, true];

	if (prj_debug) then {[format ["%1 changed to: %2",_UID,_player_table]] remoteExec ["systemChat"]};
};

prj_fnc_set_variables = {
	params ["_data"];

	for [{private _i = 0 }, { _i < (count _data) }, { _i = _i + 1 }] do {

		private _overwritting = ((_data # _i) # 2);
		
		private _variable = (call (compile ((_data # _i) # 0))) getVariable (((_data # _i) # 1) # 0);

		if (_overwritting) then {
			(call (compile ((_data # _i) # 0))) setVariable ((_data # _i) # 1);
			if (prj_debug) then {systemChat "таблица перезаписана"};
		}
		else
		{
			if (isNil "_variable") then {
				(call (compile ((_data # _i) # 0))) setVariable ((_data # _i) # 1);
				if (prj_debug) then {
					systemChat "таблица была пуста. записана новая таблица";
					systemChat format ["%1",((_data # _i) # 1)];
				};
			}
			else
			{
				if (prj_debug) then {
					systemChat "таблица уже существует. новая таблица не записана";
				};
			};
		};
	};
};

prj_fnc_add_mhq_action = {
	private _actiondeploy = [
		"a_hq_terminal_deploy",
		"Deploy MHQ",
		"\A3\Ui_f\data\Map\Markers\NATO\b_hq.paa",
		{
			([mhqterminal,3] call BIS_fnc_dataTerminalAnimate);
			([mhqterminal, -1] call ace_cargo_fnc_setSize);
			([mhqterminal, false, [0, 1.4, 0], 90] call ace_dragging_fnc_setDraggable)
		},
		{true}
	] call ace_interact_menu_fnc_createAction;

	[mhqterminal, 0, ["ACE_MainActions"], _actiondeploy] call ace_interact_menu_fnc_addActionToObject;

	private _actionundeploy = [
		"a_hq_terminal_undeploy",
		"Undeploy MHQ",
		"\A3\Ui_f\data\Map\Markers\NATO\b_hq.paa",
		{
			([mhqterminal,0] call BIS_fnc_dataTerminalAnimate);
			([mhqterminal, 3] call ace_cargo_fnc_setSize);
			([mhqterminal, true, [0, 1.4, 0], 90] call ace_dragging_fnc_setDraggable)
		},
		{true}
	] call ace_interact_menu_fnc_createAction;

	[mhqterminal, 0, ["ACE_MainActions"], _actionundeploy] call ace_interact_menu_fnc_addActionToObject;
};

prj_fnc_create_task = {
	private _taskID = missionNamespace getVariable ["taskID",0];
	private _oldTaskName = missionNamespace getVariable ["oldTaskName","side_null"];

	private _tasks = [
		["side_alarm_button",100],
		["side_ammo_cache",200],
		["side_capture_leader",200],
		["side_capture_zone",180],
		["side_checkpoint",130],
		["side_destroy_tower",200],
		["side_destruction_of_vehicles",200],
		["side_hostage",200],
		["side_humanitarian_aid",100],
		["side_intel_uav",200],
		["side_liquidation_leader",100],
		["side_rescue",200]
	];

	private _selected_task = selectRandom _tasks;

	while {(_selected_task # 0) != _oldTaskName} do {_selected_task = selectRandom _tasks};

	[_taskID,(_selected_task # 1)] execVM "core\tasks\side\" + (_selected_task # 0) + ".sqf";

	private _taskID = missionNamespace setVariable ["taskID",_taskID + 1,true];
	private _oldTaskName = missionNamespace setVariable ["oldTaskName",_selected_task # 0,true];

	if (prj_debug) then {
		systemChat format ["id: %1 | task: %2 | reward: %3",_taskID, _selected_task # 0, _selected_task # 1];
	};
};

prj_fnc_cancel_task = {
	params ["_task"];

	if (_task isEqualTo "") exitWith {hint localize "STR_PRJ_SELECT_TASK_ON_MAP"};

	private "_task";

	private _subTasks = _task call BIS_fnc_taskChildren;
	if (_subTasks isEqualTo []) then {
		private _taskParent = _task call BIS_fnc_taskParent;
		if !(_taskParent isEqualTo "") then {
			_task = _taskParent;
			_subTasks = _task call BIS_fnc_taskChildren;
		};
	};

	([_task] + _subTasks) apply {
		if !(_x call BIS_fnc_taskCompleted) then {
			[_x, "CANCELED"] call BIS_fnc_taskSetState
		} else {
			false
		};
	};
};

prj_fnc_civ_orders = {
	params ["_order","_position"];

	private _list = _position nearEntities [["Man"], 60];
	private _units = _list select {!(_x isEqualTo player) && ((side _x) isEqualTo civilian)};

	if (_units isEqualTo []) exitWith {true};
	{
		for "_i" from (count waypoints (group _x)) - 1 to 0 step -1 do {
			deleteWaypoint [group _x, _i];
		};
		(group _x) setBehaviour "CARELESS";
		switch (_order) do {
			case 1 : {
				doStop _x;
			};
			case 2 : {
				if ((animationState _x) == "amovpercmstpssurwnondnon") then {
					[_x, "AmovPercMstpSsurWnonDnon_AmovPercMstpSnonWnonDnon"] remoteExec ["switchMove", 0];
				};
				doStop _x;
				_x setUnitPos "DOWN";
			};
			case 3 : {
				if ((animationState _x) == "amovpercmstpssurwnondnon") then {
					[_x, "AmovPercMstpSsurWnonDnon_AmovPercMstpSnonWnonDnon"] remoteExec ["switchMove", 0];
				};
				_x setUnitPos "UP";
				(group _x) setSpeedMode "FULL";
				[_x] call ace_interaction_fnc_sendAway;
			};
			case 4 : {
				_x setUnitPos "UP";
				doStop _x;
				[_x, "AmovPercMstpSsurWnonDnon"] remoteExec ["playMove", 0];
			};
		};
	} forEach _units;
};

prj_fnc_civ_info = {
	params ["_position","_civilian"];

	private _kill_enemy = missionNamespace getVariable "total_kill_enemy";
	private _civ_enemy = missionNamespace getVariable "total_kill_civ";

	if !(player getVariable ["interpreter",false]) exitWith {
		[localize "STR_PRJ_CIVIL", localize (selectRandom ["STR_PRJ_CIVIL_DOES_NOT_UNDERSTAND_1","STR_PRJ_CIVIL_DOES_NOT_UNDERSTAND_2","STR_PRJ_CIVIL_DOES_NOT_UNDERSTAND_3"])] spawn BIS_fnc_showSubtitle;
	};

	if (_kill_enemy - (_civ_enemy * 5)) exitWith {
		[localize "STR_PRJ_CIVIL", localize (selectRandom ["STR_PRJ_CIVIL_BAD_KARMA_1","STR_PRJ_CIVIL_BAD_KARMA_2","STR_PRJ_CIVIL_BAD_KARMA_3"])] spawn BIS_fnc_showSubtitle;
	};

	if (_civilian getVariable ["interviewed",false]) exitWith {
		[localize "STR_PRJ_CIVIL", localize (selectRandom ["STR_PRJ_CIVIL_INFO_INTERVIEWED_1","STR_PRJ_CIVIL_INFO_INTERVIEWED_2","STR_PRJ_CIVIL_INFO_INTERVIEWED_3"])] spawn BIS_fnc_showSubtitle;
	};

	private _array = _position nearEntities [enemy_infantry, 1500];
	if (!(_array isEqualTo []) && (random 1 < 0.7)) then {
		private _man = _array # 0;
		private _distance = (_position distance _man) + (round (random 150)) - (round (random 150));
		private _dir = _position getDir _man;

		switch (true) do {
			case (_dir > 345 || _dir <= 15) : {card = localize "STR_PRJ_SIDE_WORLD_N"};
			case (_dir > 15 && _dir <= 75) : {card = localize "STR_PRJ_SIDE_WORLD_NE"};
			case (_dir > 75 && _dir <= 105) : {card = localize "STR_PRJ_SIDE_WORLD_E"};
			case (_dir > 105 && _dir <= 165) : {card = localize "STR_PRJ_SIDE_WORLD_SE"};
			case (_dir > 165 && _dir <= 195) : {card = localize "STR_PRJ_SIDE_WORLD_S"};
			case (_dir > 195 && _dir <= 255) : {card = localize "STR_PRJ_SIDE_WORLD_SW"};
			case (_dir > 255 && _dir <= 285) : {card = localize "STR_PRJ_SIDE_WORLD_W"};
			case (_dir > 285 && _dir <= 345) : {card = localize "STR_PRJ_SIDE_WORLD_NW"};
		};

		[localize "STR_PRJ_CIVIL", format [localize (selectRandom ["STR_PRJ_CIVIL_INFO_1_INF","STR_PRJ_CIVIL_INFO_2_INF","STR_PRJ_CIVIL_INFO_3_INF"]), card, round _distance]] spawn BIS_fnc_showSubtitle;
	}
	else
	{
		[localize "STR_PRJ_CIVIL", localize (selectRandom ["STR_PRJ_CIVIL_INFO_NEGATIVE_1","STR_PRJ_CIVIL_INFO_NEGATIVE_2","STR_PRJ_CIVIL_INFO_NEGATIVE_3"])] spawn BIS_fnc_showSubtitle;
	};

	_civilian setVariable ["interviewed",true,true];
};