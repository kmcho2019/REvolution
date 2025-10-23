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
    assign heater = mode && too_cold;
    
    // Cooling mode: aircon on when too hot
    assign aircon = !mode && too_hot;
    
    // Fan control: OR of all activation sources
    // heater and aircon are mutually exclusive
    assign fan = fan_on || heater || aircon;

endmodule