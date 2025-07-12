module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is on when in heating mode and too cold
    assign heater = mode & too_cold;
    
    // Air conditioner is on when in cooling mode and too hot
    assign aircon = ~mode & too_hot;
    
    // Fan is on when heater or air conditioner is on, or when fan is requested
    assign fan = (mode & too_cold) | (~mode & too_hot) | fan_on;

endmodule