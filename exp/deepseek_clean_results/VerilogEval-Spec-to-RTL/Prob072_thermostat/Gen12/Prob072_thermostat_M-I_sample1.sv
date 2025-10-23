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

    // Mode-gated output assignments to reduce switching power
    assign heater = mode && too_cold;  // Only active in HEATING mode
    assign aircon = ~mode && too_hot; // Only active in COOLING mode

    // Optimized fan control - fan_on evaluated first
    assign fan = fan_on || heater || aircon;

endmodule