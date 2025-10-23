module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Control the heater based on the mode and temperature
    assign heater = mode && too_cold;

    // Control the air conditioner based on the mode and temperature
    assign aircon = ~mode && too_hot;

    // Control the fan based on whether the heater or air conditioner is on, or if the user has requested the fan to turn on
    assign fan = heater || aircon || fan_on;

endmodule