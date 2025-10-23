module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Activate heater only in heating mode when too cold
    assign heater = mode & too_cold;
    
    // Activate aircon only in cooling mode when too hot
    assign aircon = ~mode & too_hot;
    
    // Fan activates for HVAC operation or by user request
    assign fan = heater | aircon | fan_on;

endmodule