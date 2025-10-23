module TopModule (
    input  mode,       // 1=heating, 0=cooling
    input  too_cold,   // Needs heating
    input  too_hot,    // Needs cooling
    input  fan_on,     // Manual fan control
    output heater,     // Heater control
    output aircon,     // Air conditioner control
    output fan         // Fan control
);

    // Heating control: only active in heating mode when too cold
    assign heater = mode & too_cold;

    // Cooling control: only active in cooling mode when too hot
    assign aircon = ~mode & too_hot;

    // Fan control: on when either system is active or manually requested
    assign fan = heater | aircon | fan_on;

endmodule