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

    // Heating/cooling control
    assign heater = (mode == HEATING) & too_cold;
    assign aircon = (mode == COOLING) & too_hot;

    // Fan control (fan_on has priority)
    assign fan = fan_on | heater | aircon;

endmodule