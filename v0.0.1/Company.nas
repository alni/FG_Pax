var money = 0;
var routem = nil;
var currentRoute = nil;
var route_done = 0;
var route_started = 0;

Company = {};

Company.init = func {
	routem = props.globals.getNode("/autopilot/route-manager", 1);
	print("## INIT FG_Pax ##", "\n");
	_setlistener("/autopilot/route-manager/active", Company.startNewRoute);
};

Company.startNewRoute = func {
	print("route_started = ", route_started, "\n");
	print("/autopilot/route-manager/active = ", getprop("/autopilot/route-manager/active"), "\n");
	if (!route_started and getprop("/autopilot/route-manager/active")) {
		var dist_rem_node = routem.getNode("distance-remaining-nm");
		print("Distance to end: ", dist_rem_node.getValue(), "\n");
			
		route_started = 1;
		_setlistener("/autopilot/route-manager/distance-remaining-nm", Company.eventFly);
		
	}
};

Company.eventFly = func {
	print("Time in air: ", routem.getNode("flight-time").getValue(), "\n");
	print("Distance left: ", routem.getNode("distance-remaining-nm").getValue(), "\n");
	Company.earnt();
};

Company.earned = func {
	var dist_rem = routem.getNode("distance-remaining-nm").getValue();
	var airborne = routem.getNode("airborne").getValue();
	if (!route_done and dist_rem <= 1 and !airborne) {
		var time_flown = me.routem.getNode("flight-time").getValue();
		var earnt = (time_flown / 60.0) * 250;

		money = money + earnt;
		print("Earn on this route: $", earnt, "\n");
		print("Money: $", money, "\n");

		route_done = 1;
	}
};