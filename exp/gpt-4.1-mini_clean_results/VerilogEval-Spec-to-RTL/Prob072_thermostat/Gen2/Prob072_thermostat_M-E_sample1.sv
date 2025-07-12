module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    wire heat_active;
    wire cool_active;

    // Determine heating and cooling states
    assign heat_active = (mode == 1'b1) && (too_cold == 1'b1);
    assign cool_active = (mode == 1'b0) && (too_hot == 1'b1);

    // Outputs for heater and aircon
    assign heater = heat_active;
    assign aircon = cool_active;

    // Fan is on if heating or cooling active, or fan_on asserted
    assign fan = heat_active | cool_active | fan_on;

endmodule