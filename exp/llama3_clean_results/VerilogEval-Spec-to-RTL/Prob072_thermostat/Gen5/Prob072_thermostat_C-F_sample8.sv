module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Directly assign heater and aircon based on mode and temperature conditions
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    
    // Simplified fan logic: turn on the fan when the heater or air conditioner is on, or when the fan is requested
    assign fan = (heater | aircon) | fan_on;

endmodule