module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Determine when to turn on the heater
    assign heater = mode & too_cold;

    // Determine when to turn on the air conditioner
    assign aircon = ~mode & too_hot;

    // Determine when to turn on the fan
    assign fan = (heater | aircon) | fan_on;

endmodule