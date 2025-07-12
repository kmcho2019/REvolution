module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Mode definitions for code clarity
    localparam HEATING = 1'b1;
    localparam COOLING = 1'b0;

    // Heating control: active only in heating mode when too cold
    assign heater = (mode == HEATING) & too_cold;

    // Cooling control: active only in cooling mode when too hot
    assign aircon = (mode == COOLING) & too_hot;

    // Fan control: on when either:
    // 1. User requests (fan_on)
    // 2. Heater is active
    // 3. Aircon is active
    // fan_on placed first for potential switching optimization
    assign fan = fan_on | heater | aircon;

endmodule