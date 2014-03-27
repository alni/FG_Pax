var money = 0;
var currentRoute = nil;
var route_done = 0;
var route_started = 0;
var listener_distance = nil;
var num_listeners = nil;

Company = {};

Company.init = func {
	print("## INIT FG_Pax ##", "\n");
};

Company.startNewRoute = func {
	print("route_started = ", route_started, "\n");
	print("/autopilot/route-manager/active = ", getProp("/autopilot/route-manager/active"), "\n");
	if (!route_started and getProp("/autopilot/route-manager/active")) {
		print("Distance to end: ", getProp("/autopilot/route-manager/distance-remaining-nm"), "\n");
			
		route_started = 1;
		listener_distance = _setListener("/autopilot/route-manager/distance-remaining-nm", Company.eventFly);
	}
};

Company.cancelRoute = func {
	route_started = 0;
	currentRoute = nil;
	route_done = 0;
	num_listeners = removelistener(listener_distance);
	if (!num_listeners) {
		print("Unable to remove listener_distance", "\n");
	} else {
		print("Listeners remaining: ", num_listener, "\n");
	}
};

Company.eventFly = func {
	print("Time in air: ", getProp("/autopilot/route-manager/flight-time"), "\n");
	print("Distance left: ", getProp("/autopilot/route-manager/distance-remaining-nm"), "\n");
	Company.earned();
};

Company.earned = func {
	var dist_rem = getProp("/autopilot/route-manager/distance-remaining-nm");
	var airborne = getProp("/autopilot/route-manager/airborne");
	if (!route_done and dist_rem <= 1 and !airborne and route_started) {
		var time_flown = getProp("/autopilot/route-manager/flight-time");
		var earned = (time_flown / 60.0) * 250;

		money = money + earned;
		print("Earn on this route: $", earned, "\n");
		print("Money: $", money, "\n");

		route_done = 1;
	}
};