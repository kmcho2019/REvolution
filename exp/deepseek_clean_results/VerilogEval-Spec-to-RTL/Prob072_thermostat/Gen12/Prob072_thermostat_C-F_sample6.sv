module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // State definitions (documentation only - not synthesized)
    localparam HEATING  = 0; // Mode=1 & too_cold
    localparam COOLING  = 1; // Mode=0 & too_hot
    localparam FAN_ONLY = 2; // fan_on without heating/cooling
    localparam IDLE     = 3; // No activity

    // Output logic
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    assign fan = fan_on | heater | aircon;

endmodule