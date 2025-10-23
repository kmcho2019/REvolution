module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heating mode: activate heater when too cold
    assign heater = (mode == 1'b1) & too_cold;

    // Cooling mode: activate aircon when too hot
    assign aircon = (mode == 1'b0) & too_hot;

    // Fan control: active when either system is running or manually requested
    assign fan = (heater | aircon | fan_on);

endmodule