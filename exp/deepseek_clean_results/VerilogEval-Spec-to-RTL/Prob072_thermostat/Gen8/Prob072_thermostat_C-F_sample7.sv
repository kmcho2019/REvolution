module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Mode definitions for clarity
    localparam HEATING = 1'b1;
    localparam COOLING = 1'b0;

    // Direct output assignments
    assign heater = (mode == HEATING) & too_cold;
    assign aircon = (mode == COOLING) & too_hot;
    
    // Fan is active when explicitly requested or when heating/cooling
    // fan_on placed first for potential switching optimization
    assign fan = fan_on | heater | aircon;

endmodule