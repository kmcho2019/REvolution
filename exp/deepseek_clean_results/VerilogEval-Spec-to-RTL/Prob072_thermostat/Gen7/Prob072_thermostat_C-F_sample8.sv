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

    // Heater is active only in heating mode when too cold
    assign heater = (mode == HEATING) & too_cold;

    // Aircon is active only in cooling mode when too hot
    // Note: heater and aircon are mutually exclusive due to mode
    assign aircon = (mode == COOLING) & too_hot;

    // Fan is active when explicitly requested or when heating/cooling
    // fan_on placed first for potential switching optimization
    assign fan = fan_on | heater | aircon;

endmodule