module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // State definitions (documentation only - not used in logic)
    localparam HEATING  = 2'b01;
    localparam COOLING  = 2'b10;
    localparam FAN_ONLY = 2'b00;
    
    // Mode-dependent outputs
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    
    // Optimized fan logic - uses precomputed heater/aircon signals
    assign fan = heater | aircon | fan_on;

endmodule