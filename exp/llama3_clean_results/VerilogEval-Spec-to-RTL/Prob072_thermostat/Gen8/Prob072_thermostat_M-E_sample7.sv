module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Sub-module to determine the heating/cooling mode
    wire heating_mode;
    assign heating_mode = mode;

    // Sub-module to control the heater/air conditioner
    wire heat_control, cool_control;
    assign heat_control = heating_mode & too_cold;
    assign cool_control = ~heating_mode & too_hot;

    // Sub-module to control the fan
    wire fan_control;
    assign fan_control = heat_control | cool_control | fan_on;

    // Assign outputs
    assign heater = heat_control;
    assign aircon = cool_control;
    assign fan = fan_control;

endmodule