module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(*) begin
    // Initialize outputs to default values
    heater = 0;
    aircon = 0;
    fan = 0;

    // Determine whether to turn on the heater or air conditioner
    if (mode) begin
        // Heating mode
        if (too_cold) begin
            heater = 1;
        end
    end else begin
        // Cooling mode
        if (too_hot) begin
            aircon = 1;
        end
    end

    // Turn on the fan if the heater or air conditioner is on, or if the user requests it
    if (heater || aircon || fan_on) begin
        fan = 1;
    end
end

endmodule