module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Directly assign heater and aircon using logical operators for clarity
    assign heater = mode && too_cold;
    assign aircon = !mode && too_hot;

    // Simplify fan assignment by directly using heater and aircon
    assign fan = heater || aircon || fan_on;

endmodule