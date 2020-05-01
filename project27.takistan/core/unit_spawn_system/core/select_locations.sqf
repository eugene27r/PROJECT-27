/*
	written by eugene27.
	server only
	1.3.0
*/

private _safe_radius = 2000;
private _distance = 600;
prj_debug = false;

private _all_locations = ["NameCityCapital","NameCity","NameVillage","NameLocal","Hill","RockArea","VegetationBroadleaf","VegetationFir","VegetationPalm","VegetationVineyard","ViewPoint","BorderCrossing"];

systemChat format ["%1",cities_enemy];
systemChat format ["%1",ied];

private _types_locations = [
	["NameCityCapital",325,[cities_enemy,cities_civilian]],
	["NameCity",325,[cities_enemy,cities_civilian]],
	["NameVillage",325,[villages_enemy,villages_civilian]],
	["NameLocal",325,[local_enemy,local_civilian]],
	["Hill",50,[hills_enemy,hills_civilian]],
	["RockArea",125,[rock_enemy,rock_civilian]],
	["VegetationBroadleaf",175,[vegetation_enemy,vegetation_civilian]],
	["VegetationFir",175,[vegetation_enemy,vegetation_civilian]],
	["VegetationPalm",175,[vegetation_enemy,vegetation_civilian]],
	["VegetationVineyard",175,[vegetation_enemy,vegetation_civilian]],
	["ViewPoint",150,[other_enemy,other_civilian]],
	["BorderCrossing",100,[other_enemy,other_civilian]]
];

private _delete_locations = nearestLocations [position Checkpoint1, _all_locations, _safe_radius] + nearestLocations [position Checkpoint2, _all_locations, _safe_radius];

private _house_ieds_class = ["rhs_mine_a200_dz35","rhs_mine_stockmine43_2m","APERSTripMine","rhs_mine_mk2_pressure"];

for [{private _i = 0 }, { _i < (count _types_locations) }, { _i = _i + 1 }] do {

	private _locations = (nearestLocations [[worldSize / 2, worldsize / 2, 0], [(_types_locations select _i) select 0], worldSize * 1.5]) - _delete_locations;

	private _spawn_area = (_types_locations select _i) select 1;

	{
		private _pos = locationPosition _x;
		private _trigger = createTrigger ["EmptyDetector",_pos,false];
		_trigger setTriggerArea [(_distance + _spawn_area),(_distance + _spawn_area),0,false]; 
		_trigger setTriggerActivation ["ANYPLAYER","PRESENT",true];
		_trigger setTriggerTimeout [1, 1, 1, true];
		_trigger setTriggerStatements ["{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 150 && (speed _x < 180)} count playableunits > 0", "[thisTrigger] execVM 'core\unit_spawn_system\core\spawn_core.sqf'", ""];
		_trigger setVariable ["config",(_types_locations select _i) select 2];

		private _buildings = nearestObjects [_pos, ["Building"], _spawn_area];
		if (!(_buildings isEqualTo [])) then {
			private _useful = _buildings select {!((_x buildingPos -1) isEqualTo []) && {damage _x isEqualTo 0}};
			if ((count _useful) > 5) then {
				for "_i" from 1 to (round ((count _useful) / 5)) do {
					private _allpositions = (selectRandom _useful) buildingPos -1;
					private _house_ied = createMine [selectRandom _house_ieds_class, selectRandom _allpositions,[],1];
					if (prj_debug) then {
						private _marker_house = createMarker ["house_ied_" + str (position _house_ied), position _house_ied];
						_marker_house setMarkerType "mil_dot";
						_marker_house setMarkerAlpha 1;
						_marker_house setMarkerColor "ColorWEST";
					};
				};
			};
		};

		if (prj_debug) then {
			private _marker_area = createMarker ["_area_marker_" + str _pos, _pos]; 
			_marker_area setMarkerSize [_spawn_area,_spawn_area];
			_marker_area setMarkerShape "ELLIPSE";
			_marker_area setMarkerColor "ColorOPFOR";
			_marker_area setMarkerAlpha 0.7;

			private _marker_trg = createMarker ["_area_trigger_marker_" + str _pos, _pos];
			_marker_trg setMarkerSize [(_distance + _spawn_area),(_distance + _spawn_area)];
			_marker_trg setMarkerShape "ELLIPSE";
			_marker_trg setMarkerColor "ColorBLUFOR";
			_marker_trg setMarkerAlpha 0.3;
		};
	} forEach _locations;
};

//create ied on the roads
private _junk_class = ["Land_Garbage_square3_F","Land_Garbage_square5_F","Land_Garbage_line_F"];

private _number_of_ied = "number_of_ied" call BIS_fnc_getParamValue;
private _safe_radius = "ied_safe_radius" call BIS_fnc_getParamValue;

private _roads = ([worldSize / 2, worldsize / 2, 0] nearRoads (worldSize * 1.5)) - (position Checkpoint1 nearRoads _safe_radius) - (position Checkpoint2 nearRoads _safe_radius);

for "_i" from 1 to _number_of_ied do {
	private _ied = createMine [selectRandom ied, (position (selectRandom _roads)),[],3];
	if ((random 1) < 0.7) then {
		_junk = selectRandom _junk_class createVehicle position _ied;
		_junk enableSimulationGlobal false;
	};
	private _junk = selectRandom _junk_class createVehicle (position (selectRandom _roads));
	_junk enableSimulationGlobal false;

	if (prj_debug) then {
		private _marker_junk = createMarker ["junk_" + str (position _junk), position _junk];
		_marker_junk setMarkerType "mil_dot";
		_marker_junk setMarkerAlpha 1;
		_marker_junk setMarkerColor "ColorWEST";

		private _marker_ied = createMarker ["ied_" + str (position _ied), position _ied];
		_marker_ied setMarkerType "mil_dot";
		_marker_ied setMarkerAlpha 1;
		_marker_ied setMarkerColor "ColorOPFOR";
	};
};

{independent revealMine _x} forEach allMines;