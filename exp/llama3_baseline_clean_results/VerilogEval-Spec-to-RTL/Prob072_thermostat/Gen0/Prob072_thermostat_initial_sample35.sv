module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // heater is on when it's too cold and in heating mode
    assign heater = mode && too_cold;
    
    // aircon is on when it's too hot and in cooling mode
    assign aircon = ~mode && too_hot;
    
    // fan is on when heater or aircon is on, or when fan_on is requested
    assign fan = (heater || aircon) || fan_on;

endmodule