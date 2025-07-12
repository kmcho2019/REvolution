module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // In heating mode, turn on the heater if it's too cold
    assign heater = mode & too_cold;
    
    // In cooling mode, turn on the air conditioner if it's too hot
    assign aircon = ~mode & too_hot;
    
    // Turn on the fan whenever the heater or air conditioner is on, or when the user requests the fan to be on
    assign fan = (heater | aircon) | fan_on;

endmodule