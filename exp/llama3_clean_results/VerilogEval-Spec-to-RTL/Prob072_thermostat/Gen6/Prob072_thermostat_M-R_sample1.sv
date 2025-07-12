module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Simplified logic for the heater and air conditioner using assign
    assign heater = mode && too_cold;
    assign aircon = ~mode && too_hot;
    assign fan = (heater || aircon) || fan_on;

endmodule