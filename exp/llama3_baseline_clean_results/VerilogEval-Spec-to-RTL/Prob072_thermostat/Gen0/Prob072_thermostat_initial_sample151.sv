module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Determine the state of the heater based on the mode and temperature
    assign heater = mode & too_cold;

    // Determine the state of the air conditioner based on the mode and temperature
    assign aircon = ~mode & too_hot;

    // Determine the state of the fan based on the states of the heater, air conditioner, and user request
    assign fan = heater | aircon | fan_on;

endmodule