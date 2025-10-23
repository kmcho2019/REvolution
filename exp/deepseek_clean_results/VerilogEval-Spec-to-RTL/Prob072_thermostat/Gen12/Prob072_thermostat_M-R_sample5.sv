module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heating mode: heater on when too cold
    assign heater = mode & too_cold;
    
    // Cooling mode: aircon on when too hot
    assign aircon = ~mode & too_hot;
    
    // Fan on when either heater, aircon, or manual fan request is active
    assign fan = heater | aircon | fan_on;

endmodule