module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Direct combinational outputs (optimized)
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    assign fan = fan_on | (mode ? too_cold : too_hot);  // heater and aircon are mutually exclusive

endmodule