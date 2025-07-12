module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Temperature control outputs
    assign heater = mode && too_cold;      // mode=1 (heating) and too_cold
    assign aircon = ~mode && too_hot;     // mode=0 (cooling) and too_hot

    // Fan control: user request OR system needs
    assign fan = fan_on || (heater || aircon);

endmodule