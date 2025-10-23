module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Determine the heater output based on the mode and temperature
    assign heater = (mode == 1'b1) && (too_cold == 1'b1);

    // Determine the air conditioner output based on the mode and temperature
    assign aircon = (mode == 1'b0) && (too_hot == 1'b1);

    // Determine the fan output based on the heater, air conditioner, and fan_on signals
    assign fan = (heater == 1'b1) || (aircon == 1'b1) || (fan_on == 1'b1);

endmodule