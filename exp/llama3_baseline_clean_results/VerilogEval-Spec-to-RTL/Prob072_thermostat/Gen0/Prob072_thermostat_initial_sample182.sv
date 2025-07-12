module TopModule (
    input  mode,       // 1 for heating, 0 for cooling
    input  too_cold,   // temperature status
    input  too_hot,    // temperature status
    input  fan_on,     // user request to turn on the fan
    output heater,     // heater output
    output aircon,     // air conditioner output
    output fan         // fan output
);

    // Turn on the heater when it's too cold and in heating mode
    assign heater = mode && too_cold;
    
    // Turn on the air conditioner when it's too hot and in cooling mode
    assign aircon = ~mode && too_hot;
    
    // Turn on the fan if either the heater or air conditioner is on, or if the user requests it
    assign fan = (heater || aircon) || fan_on;

endmodule