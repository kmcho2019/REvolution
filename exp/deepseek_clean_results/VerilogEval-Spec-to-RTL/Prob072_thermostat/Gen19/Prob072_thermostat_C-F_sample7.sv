module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // State parameters for clarity (from Example 2)
    localparam COOLING = 1'b0;
    localparam HEATING = 1'b1;

    // Direct combinational logic (from Example 1)
    assign heater = (mode == HEATING) & too_cold;
    assign aircon = (mode == COOLING) & too_hot;
    assign fan = fan_on | heater | aircon;

endmodule