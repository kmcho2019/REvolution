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

    // Directly assign fan using a combination of logical and bitwise operators
    assign fan = (mode && too_cold) || (!mode && too_hot) || fan_on;

endmodule