var money = 0;
var currentRoute = nil;
var route_done = 0;
var route_started = 0;

Company = {};

Company.init = func {
	print("## INIT FG_Pax ##", "\n");
	_setListener("/autopilot/route-manager/active", Company.startNewRoute);
};

Company.startNewRoute = func {
	print("route_started = ", route_started, "\n");
	print("/autopilot/route-manager/active = ", getProp("/autopilot/route-manager/active"), "\n");
	if (!route_started and getProp("/autopilot/route-manager/active")) {
		print("Distance to end: ", getProp("/autopilot/route-manager/distance-remaining-nm"), "\n");
			
		route_started = 1;
		_setListener("/autopilot/route-manager/distance-remaining-nm", Company.eventFly);
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
	if (!route_done and dist_rem <= 1 and !airborne) {
		var time_flown = getProp("/autopilot/route-manager/flight-time");
		var earned = (time_flown / 60.0) * 250;

		money = money + earned;
		print("Earn on this route: $", earned, "\n");
		print("Money: $", money, "\n");

		route_done = 1;
	}
};