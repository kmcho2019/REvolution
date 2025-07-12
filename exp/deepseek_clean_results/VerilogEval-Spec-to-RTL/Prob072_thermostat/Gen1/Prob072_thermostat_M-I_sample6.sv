module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    wire heating_mode = mode;
    wire cooling_mode = ~mode;
    
    // Heater control: active only in heating mode when too cold
    assign heater = heating_mode & too_cold;
    
    // Aircon control: active only in cooling mode when too hot
    assign aircon = cooling_mode & too_hot;
    
    // Fan control: active when either HVAC system is on or by user request
    assign fan = heater | aircon | fan_on;

endmodule