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

    // Direct assignments for heater and aircon
    assign heater = (mode == HEATING) & too_cold;
    assign aircon = (mode == COOLING) & too_hot;

    // Optimized fan logic using existing outputs
    // fan_on placed first for potential switching optimization
    assign fan = fan_on | heater | aircon;

endmodule