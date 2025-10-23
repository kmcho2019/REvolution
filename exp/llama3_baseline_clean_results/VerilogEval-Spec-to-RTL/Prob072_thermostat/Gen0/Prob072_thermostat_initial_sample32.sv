module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Determine the heater state based on the mode and temperature
    assign heater = mode & too_cold;

    // Determine the air conditioner state based on the mode and temperature
    assign aircon = ~mode & too_hot;

    // Determine the fan state based on the heater, air conditioner, and fan_on inputs
    assign fan = (heater | aircon | fan_on);

endmodule