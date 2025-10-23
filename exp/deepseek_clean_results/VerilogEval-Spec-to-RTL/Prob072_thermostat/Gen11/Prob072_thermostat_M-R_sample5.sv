module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // Mode definitions
    localparam HEATING = 1'b1;
    localparam COOLING = 1'b0;

    always_comb begin
        // Heating mode controls
        if (mode == HEATING) begin
            heater = too_cold;
            aircon = 1'b0;  // Explicitly off in heating mode
        end
        // Cooling mode controls
        else begin
            heater = 1'b0;  // Explicitly off in cooling mode
            aircon = too_hot;
        end

        // Fan control (user request has priority)
        fan = fan_on || (heater || aircon);
    end

endmodule