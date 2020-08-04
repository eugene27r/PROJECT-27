/* 
	written by eugene27.
	server only
*/

params ["_trigger"];

if (prj_debug) then {
	[format ["%1 activated\nenemy - %2\nciv - %3",_trigger,(_trigger getVariable "config") # 0,(_trigger getVariable "config") # 1]] remoteExec ["hint",0];
};

private _distance = 600;
private _trigger_pos = position _trigger;
private _trigger_radius = ((triggerArea _trigger) # 0) - _distance;

//functions
prj_fnc_number_of_units = {
	params ["_number"];

	private _number_result = switch (_number) do {
		case 0: {1};
		case 1: {[2,4] call BIS_fnc_randomInt};
		case 2: {[4,8] call BIS_fnc_randomInt};
		case 3: {[8,12] call BIS_fnc_randomInt};
		default {1};
	};
	_number_result
};

prj_fnc_spawn_house_groups = {
	params ["_side","_class_units","_config"];

	if (((_config # 0) # 0) == 0) exitWith {[]};

	private "_house_pos";
	private _house_units = [];
	private _buildings = nearestObjects [_trigger_pos, ["Building"], _trigger_radius];
	private _useful = _buildings select {!((_x buildingPos -1) isEqualTo []) && {damage _x isEqualTo 0}};

	for [{private _i = 0 }, { _i < ((_config # 0) # 0) }, { _i = _i + 1 }] do {
		private _group = createGroup _side;
		for [{private _i = 0 }, { _i < [((_config # 0) # 1)] call prj_fnc_number_of_units }, { _i = _i + 1 }] do {
			if ((count _useful) > 5) then {
				_allpositions = (selectRandom _useful) buildingPos -1;
				_house_pos = selectRandom _allpositions;
			};
			if (!isNil "_house_pos") then {
				private _unit = _group createUnit [selectRandom _class_units, _house_pos, [], 0, "NONE"];
				doStop _unit;
				_house_units pushBack _unit;
			};
			if (prj_debug) then {systemChat "юнит создан в доме"};
			uiSleep 0.5;
		};
	};
	_house_units
};

prj_fnc_spawn_patrols_groups = {
	params ["_side","_class_units","_config"];

	if (((_config # 1) # 0) == 0) exitWith {[]};

	private _patrols_units = [];

	for [{private _i = 0 }, { _i < ((_config # 1) # 0) }, { _i = _i + 1 }] do {
		private _group = createGroup _side;
		private _pos = [_trigger_pos, 10, _trigger_radius, 1, 0] call BIS_fnc_findSafePos;
		if (!isNil "_pos") then {
			for [{private _i = 0 }, { _i < [((_config # 1) # 1)] call prj_fnc_number_of_units }, { _i = _i + 1 }] do {
				private _unit = _group createUnit [selectRandom _class_units, _pos, [], 0, "NONE"];
				_patrols_units pushBack _unit;
				if (prj_debug) then {systemChat "юнит патруля создан"};
				uiSleep 0.5;
			};
			_group setBehaviour "SAFE";
			_group setSpeedMode "LIMITED";
			_group setCombatMode "YELLOW";
			_group setFormation (["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND"] call BIS_fnc_selectRandom);

			//create waypoints
			for "_i" from 1 to 5 do {
				private _pos = [_trigger_pos, 10, _trigger_radius, 1, 0] call BIS_fnc_findSafePos;
				private _wp = _group addWaypoint [_pos, 0];
				_wp setWaypointType "MOVE";
				_wp setWaypointCompletionRadius 50;
				_wp setWaypointTimeout [0,2,6];
				if (prj_debug) then {systemChat "WP для группы создан"};
			};

			private _pos_wp = [_trigger_pos, 10, _trigger_radius, 1, 0] call BIS_fnc_findSafePos;

			private _wp_cycle = _group addWaypoint [_pos_wp, 0];
			_wp_cycle setWaypointType "CYCLE";
			_wp_cycle setWaypointCompletionRadius 50;
		};
		uiSleep 0.5;
	};
	_patrols_units
};

prj_fnc_spawn_vehicles = {
	params ["_side","_class_units","_class_vehicles","_config",["_index_config",2],["_behaviour","SAFE"]];

	if (((_config # _index_config) # 0) == 0) exitWith {[]};

	private _vehicles = [];
	private _vehicle_crew_units = [];
	private _roads = (_trigger_pos) nearRoads _trigger_radius;
	_roads = _roads select {isOnRoad _x};

	for [{private _i = 0 }, { _i < ((_config # _index_config) # 0) }, { _i = _i + 1 }] do {

		if ((random 1) < (_config # _index_config) # 1) then {

			private ["_pos","_pos_wp","_direction"];

			if ((count _roads) > 5) then {
				_road = selectRandom _roads;
				_pos = getPos _road;
				_pos set [2, 0];
				_roadConnectedTo = roadsConnectedTo _road;
				_connectedRoad = _roadConnectedTo # 0;
				_direction = _road getDir _connectedRoad;
			}
			else
			{
				_pos = [_trigger_pos, 0, _trigger_radius, 5, 0] call BIS_fnc_findSafePos;
				_direction = 0;
			};

			if (prj_debug) then {systemChat "позиция спавна транспорта выбрана"};

			if (isNil "_pos") exitWith {};

			_vehicle = (selectRandom _class_vehicles) createVehicle _pos;
			_vehicle setDir _direction;
			_vehicles pushBack _vehicle;

			if (prj_debug) then {systemChat "транспорт создан"};

			uiSleep 0.5;

			//create crew
			private _vehicle_crew_group = createGroup _side;

			if ((_vehicle emptyPositions "commander") != 0) then {
				private _unit = _vehicle_crew_group createUnit [selectRandom _class_units, _pos, [], 0, "NONE"];
				_unit moveInCommander _vehicle;
				_vehicle_crew_units pushBack _unit;
				if (prj_debug) then {systemChat "командир создан"};
			};

			if ((_vehicle emptyPositions "gunner") != 0) then {
				private _unit = _vehicle_crew_group createUnit [selectRandom _class_units, _pos, [], 0, "NONE"];
				_unit moveInGunner _vehicle;
				_vehicle_crew_units pushBack _unit;
				if (prj_debug) then {systemChat "стрелок создан"};
			};

			if ((_vehicle emptyPositions "driver") != 0) then {
				private _unit = _vehicle_crew_group createUnit [selectRandom _class_units, _pos, [], 0, "NONE"];
				_unit moveInDriver _vehicle;
				_vehicle_crew_units pushBack _unit;
				if (prj_debug) then {systemChat "водитель создан"};
			};
			
			uiSleep 0.5;

			//create passengers
			private _empty_seats = round (random (_vehicle emptyPositions "cargo"));

			for "_i" from 1 to _empty_seats do {
				private _unit = _vehicle_crew_group createUnit [selectRandom _class_units, _pos, [], 0, "NONE"];
				_unit moveInCargo _vehicle;
				_vehicle_crew_units pushBack _unit;
				if (prj_debug) then {systemChat "пассажир создан"};
				uiSleep 0.3;
			};

			_vehicle_crew_group setBehaviour _behaviour;
			_vehicle_crew_group setSpeedMode "LIMITED";
			_vehicle_crew_group setCombatMode "YELLOW";

			//create waypoints
			for "_i" from 1 to 3 do {
				if ((count _roads) > 5) then {
					private _road = selectRandom _roads;
					_pos = getPos _road;
					_pos set [2, 0];
				}
				else
				{
					_pos = [_trigger_pos, 0, _trigger_radius, 5, 0] call BIS_fnc_findSafePos;
				};
				_wp = _vehicle_crew_group addWaypoint [_pos, 0];
				_wp setWaypointType "MOVE";
				_wp setWaypointCompletionRadius 50;
				if (prj_debug) then {systemChat "WP для транспорта создан"};
				uiSleep 0.3;
			};

			if ((count _roads) > 5) then {
				private _road = selectRandom _roads;
				_pos_wp = getPos _road;
				_pos_wp set [2, 0];
			}
			else
			{
				_pos_wp = [_trigger_pos, 0, _trigger_radius, 5, 0] call BIS_fnc_findSafePos;
			};
			private _wp_cycle = _vehicle_crew_group addWaypoint [_pos_wp, 0];
			_wp_cycle setWaypointType "CYCLE";
			_wp_cycle setWaypointCompletionRadius 50;
		};
	};
	[_vehicles,_vehicle_crew_units]
};

prj_fnc_spawn_static = {
	params ["_side","_class_units","_class_static","_config"];

	if (((_config # 4) # 0) == 0) exitWith {[]};

	private _statics = [];
	private _static_crew_units = [];

	for [{private _i = 0 }, { _i < ((_config # 4) # 0) }, { _i = _i + 1 }] do {

		if ((random 1) < (_config # 4) # 1) then {

			private _pos = [_trigger_pos, 0, _trigger_radius, 5, 0] call BIS_fnc_findSafePos;

			if (prj_debug) then {systemChat "позиция статика создан"};

			if (isNil "_pos") exitWith {};

			private _static = (selectRandom _class_static) createVehicle _pos;
			_statics pushBack _static;

			if (prj_debug) then {systemChat "статик создан"};

			//create crew
			private _static_crew_group = createGroup _side;

			if ((_static emptyPositions "commander") != 0) then {
				private _unit = _static_crew_group createUnit [selectRandom _class_units, _pos, [], 0, "NONE"];
				_unit moveInCommander _static;
				_static_crew_units pushBack _unit;
				if (prj_debug) then {systemChat "командир статика создан"};
			};

			if ((_static emptyPositions "gunner") != 0) then {
				private _unit = _static_crew_group createUnit [selectRandom _class_units, _pos, [], 0, "NONE"];
				_unit moveInGunner _static;
				_static_crew_units pushBack _unit;
				if (prj_debug) then {systemChat "стрелок статика создан"};
			};
		};
		uiSleep 0.5;
	};
	[_statics,_static_crew_units]
};

/////////////////////SPAWN ENEMY\\\\\\\\\\\\\\\\\\\\\\\\
private ["_enemy_house_units","_enemy_patrols_units","_enemy_light_vehicles","_enemy_heavy_vehicles","_enemy_statics","_capt_trg"];

if (!(_trigger getVariable "captured")) then {
	
	_enemy_house_units = [independent,enemy_infantry,(_trigger getVariable "config") # 0] call prj_fnc_spawn_house_groups;

	_enemy_patrols_units = [independent,enemy_infantry,(_trigger getVariable "config") # 0] call prj_fnc_spawn_patrols_groups;

	_enemy_light_vehicles = [independent,enemy_infantry,enemy_vehicles_light + civilian_vehicles,(_trigger getVariable "config") # 0] call prj_fnc_spawn_vehicles;

	_enemy_heavy_vehicles = [independent,enemy_infantry,enemy_vehicles_heavy,(_trigger getVariable "config") # 0,3] call prj_fnc_spawn_vehicles;

	_enemy_statics = [independent,enemy_infantry,enemy_turrets,(_trigger getVariable "config") # 0] call prj_fnc_spawn_static;

	_capt_trg = [_trigger_pos, [_trigger_radius, _trigger_radius, 50], "WEST SEIZED", "PRESENT", false, "[thisTrigger] call prj_fnc_capt_zone", false] call prj_fnc_create_trg;
	_capt_trg setVariable ["parent_trigger",_trigger];
};

/////////////////////SPAWN CIVILIAN\\\\\\\\\\\\\\\\\\\\\\\\
private _civilian_house_units = [civilian,civilian_units,(_trigger getVariable "config") # 1] call prj_fnc_spawn_house_groups;

private _civilian_patrols_units = [civilian,civilian_units,(_trigger getVariable "config") # 1] call prj_fnc_spawn_patrols_groups;

private _civilian_light_vehicles = [civilian,civilian_units,civilian_vehicles,(_trigger getVariable "config") # 1,2,"CARELESS"] call prj_fnc_spawn_vehicles;

if (!isNil "_civilian_house_units" || !isNil "_civilian_patrols_units") then {
	{
		if (side _x == civilian) then {
			[_x] spawn {
				params ["_civ"];
				_civ call prj_fnc_civ
			};
		}
	} forEach _civilian_house_units + _civilian_patrols_units;
};

waitUntil {sleep 3;!triggerActivated _trigger};

/////////////////////DELETE ALL\\\\\\\\\\\\\\\\\\\\\\\\
if (!isNil "_capt_trg") then {deleteVehicle _capt_trg};

private _global_vehicles = [];
private _global_infantry = [];

if (!isNil "_enemy_house_units") then {_global_infantry = _global_infantry + _enemy_house_units};
if (!isNil "_enemy_patrols_units") then {_global_infantry = _global_infantry + _enemy_patrols_units};
if (!isNil "_civilian_house_units") then {_global_infantry = _global_infantry + _civilian_house_units};
if (!isNil "_civilian_patrols_units") then {_global_infantry = _global_infantry + _civilian_patrols_units};

if (!isNil "_enemy_light_vehicles") then {
	_global_vehicles = _global_vehicles + (_enemy_light_vehicles # 0);
	_global_infantry = _global_infantry + (_enemy_light_vehicles # 1)
};
if (!isNil "_enemy_heavy_vehicles") then {
	_global_vehicles = _global_vehicles + (_enemy_heavy_vehicles # 0);
	_global_infantry = _global_infantry + (_enemy_heavy_vehicles # 1)
};
if (!isNil "_enemy_statics") then {
	_global_vehicles = _global_vehicles + (_enemy_statics # 0);
	_global_infantry = _global_infantry + (_enemy_statics # 1)
};
if (!isNil "_civilian_light_vehicles") then {
	_global_vehicles = _global_vehicles + (_civilian_light_vehicles # 0);
	_global_infantry = _global_infantry + (_civilian_light_vehicles # 1)
};

if (!(_global_vehicles isEqualTo [])) then {
	private _vehicles_players = [];
	{_vehicles_players pushBack (vehicle _x)} forEach allPlayers;
	_global_vehicles = _global_vehicles - _vehicles_players;
};

private _deleteArray = [_global_vehicles,_global_infantry];
for [{private _i = 0 }, { _i < (count _deleteArray) }, { _i = _i + 1 }] do {
	if (!((_deleteArray # _i) isEqualTo [])) then {
		{deleteVehicle _x} forEach (_deleteArray # _i)
	};
};

if (prj_debug) then {
	private _units_deleted = _global_vehicles + _global_infantry;
	[format ["%1 deactivated\n%2 entities deleted",_trigger,count _units_deleted]] remoteExec ["hint",0];
};