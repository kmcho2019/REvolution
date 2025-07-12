module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Simplified logic for heater and aircon based on mutual exclusivity
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    
    // Optimized fan logic to minimize gates and switching activity
    assign fan = (heater | aircon) | fan_on;

endmodule