# var money = 0;
var currentRoute = nil;
# var route_done = 0;
# var route_started = 0;
var listener_distance = nil;
var num_listeners = nil;

Company = {};

Company.init = func {
    print("## INIT FG_Pax ##", "\n");
};

Company.startNewRoute = func {
    print("route_started = ", getprop("/fg-pax/route-started"), "\n");
    print("/autopilot/route-manager/active = ", getprop("/autopilot/route-manager/active"), "\n");
    if (!getprop("/fg-pax/route-started") and getprop("/autopilot/route-manager/active")) {
        # Reset Flight Time to 0 on new route
        # as it does not reset while airborne
        # (keeps ticking even when Route Manager is not active)
        setprop("/autopilot/route-manager/flight-time", 0);

        print("Distance to end: ", getprop("/autopilot/route-manager/distance-remaining-nm"), "\n");
        
        setprop("/fg-pax/route-started", 1);
        # route_started = 1;
        listener_distance = _setlistener("/autopilot/route-manager/distance-remaining-nm", Company.eventFly);
    }
    print("route_started = ", getprop("/fg-pax/route-started"), "\n");
};

Company.cancelRoute = func {
    setprop("/fg-pax/route-started", 0);
    # route_started = 0;
    currentRoute = nil;
    setprop("/fg-pax/route-done", 0);
    # route_done = 0;
    num_listeners = removelistener(listener_distance);
    if (num_listeners != nil) {
        if (!num_listeners) {
            print("Unable to remove listener_distance", "\n");
        } else {
            print("Listeners remaining: ", num_listeners, "\n");
        }
    }
};

Company.eventFly = func {
    var ete = getprop("/autopilot/route-manager/ete");
    # var h = ete / 3600;
    # var m = (h - int(h)) * 60;
    # var s = (m - int(m)) * 60;

    # h = int(h);
    # m = int(m);
    # s = int(s);


    var ete_time = Company.formatTime(ete);
    # if (h < 10) {
    #    h = "0" ~ h;
    # }
    # if (m < 10) {
    #    m = "0" ~ m;
    # }
    # if (s < 10) {
    #    s = "0" ~ s;
    # }
    # ete_time = h ~ ":" ~ m ~ ":" ~ s;
    setprop("/fg-pax/eta", ete_time);

    var time_flown = getprop("/autopilot/route-manager/flight-time");
    var time_in_air = Company.formatTime(time_flown);
    setprop("/fg-pax/time-in-air", time_in_air);


	# print("Time in air: ", getProp("/autopilot/route-manager/flight-time"), "\n");
	# print("Distance left: ", getProp("/autopilot/route-manager/distance-remaining-nm"), "\n");

    Company.estimatedIncome();
	Company.earned();
};

Company.earned = func {
    var route_done = getprop("/fg-pax/route-done");
    var route_started = getprop("/fg-pax/route-started");
    var money = getprop("/fg-pax/money");
    if (!money) {
        money = 0;
    }

    var dist_rem = getprop("/autopilot/route-manager/distance-remaining-nm");
    var curr_wp = getprop("/autopilot/route-manager/current-wp");
    var airborne = getprop("/autopilot/route-manager/airborne");
    if (!route_done and dist_rem <= 3 and route_started) {
        var earned = Company.calculateIncome();
        money = money + earned;
        setprop("/fg-pax/money", money);
        print("Earn on this route: $", earned, "\n");
        print("Money: $", money, "\n");

        setprop("/fg-pax/route-done", 1);
        # route_done = 1;
		Company.cancelRoute();
    }
};

Company.save = func {
    var filename = getprop("/sim/fg-home") ~ "/Export/FG_Pax_Save.xml";
    io.write_properties( path: filename, prop: "/fg-pax" );
};

Company.formatTime = func(arg0) {
    var h = arg0 / 3600;
    var m = (h - int(h)) * 60;
    var s = (m - int(m)) * 60;

    h = int(h);
    m = int(m);
    s = int(s);


    var time = "";
    if (h < 10) {
        h = "0" ~ h;
    }
    if (m < 10) {
        m = "0" ~ m;
    }
    if (s < 10) {
        s = "0" ~ s;
    }
    time = h ~ ":" ~ m ~ ":" ~ s;
    return time;
};

Company.calculateIncome = func {
    var total_distance = getprop("/autopilot/route-manager/total-distance");
    # In v0.0.2 the income of a route was calculated by:
    #     flownTimeInMinutes * 250
    # In a test route that lasted about 55 minutes
    # the total income was then about:
    #     55 * 250 = 13750
    # This test route was about 293 nm.
    # Total income per mile is then about:
    #     13750 / 293 = 46.9283
    return total_distance * 46.9283;
};

Company.estimatedIncome = func {
    var time_flown = getprop("/autopilot/route-manager/flight-time");
    var ete = getprop("/autopilot/route-manager/ete");
    var estimatedIncome = ((time_flown + ete) / 60.0) * 250;

    setprop("/fg-pax/estimated-income", estimatedIncome);
};
