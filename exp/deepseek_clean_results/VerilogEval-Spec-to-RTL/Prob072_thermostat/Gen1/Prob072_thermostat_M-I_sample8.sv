module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Mode-based control with explicit case statement
    wire heater_enable = mode & too_cold;
    wire aircon_enable = ~mode & too_hot;
    
    assign heater = heater_enable;
    assign aircon = aircon_enable;
    
    // Optimized fan control with explicit conditions
    assign fan = fan_on | heater_enable | aircon_enable;

endmodule