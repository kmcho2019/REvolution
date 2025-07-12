module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heating mode logic
    assign heater = mode & too_cold;

    // Cooling mode logic
    assign aircon = ~mode & too_hot;

    // Fan logic: on when heater, aircon, or fan_on is active
    assign fan = heater | aircon | fan_on;

endmodule