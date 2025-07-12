module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Turn on the heater when it's too cold and in heating mode
    assign heater = mode & too_cold;
    
    // Turn on the air conditioner when it's too hot and in cooling mode
    assign aircon = ~mode & too_hot;
    
    // Turn on the fan when the heater or air conditioner is on, or when the user requests it
    assign fan = (heater | aircon) | fan_on;

endmodule