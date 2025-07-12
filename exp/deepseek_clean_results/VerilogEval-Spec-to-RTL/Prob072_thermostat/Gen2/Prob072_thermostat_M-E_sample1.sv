module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Define states
    localparam HEATING = 1'b1;
    localparam COOLING = 1'b0;

    // State-based control logic
    wire in_heating_mode = (mode == HEATING);
    wire in_cooling_mode = (mode == COOLING);

    // Output assignments
    assign heater = in_heating_mode & too_cold;
    assign aircon = in_cooling_mode & too_hot;
    assign fan = heater | aircon | fan_on;

endmodule