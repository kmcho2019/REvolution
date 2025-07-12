module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Mode definitions
    localparam HEATING = 1'b1;
    localparam COOLING = 1'b0;

    // Temperature control signals
    wire heating_active = (mode == HEATING) & too_cold;
    wire cooling_active = (mode == COOLING) & too_hot;

    // Output assignments
    assign heater = heating_active;
    assign aircon = cooling_active;
    
    // Priority fan control: user request first, then temperature control
    assign fan = fan_on | heating_active | cooling_active;

endmodule