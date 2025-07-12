module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // In heating mode, turn on the heater when it's too cold
    assign heater = mode & too_cold;
    
    // In cooling mode, turn on the air conditioner when it's too hot
    assign aircon = ~mode & too_hot;
    
    // Turn on the fan when the heater or air conditioner is on, or when the fan is requested
    assign fan = heater | aircon | fan_on;

endmodule