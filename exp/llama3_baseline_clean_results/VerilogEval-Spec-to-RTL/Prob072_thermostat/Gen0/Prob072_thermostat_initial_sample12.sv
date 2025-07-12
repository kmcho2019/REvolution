module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(*) begin
    // Initialize outputs
    heater = 0;
    aircon = 0;
    fan = 0;

    // Check mode
    if (mode) begin // Heating mode
        // Turn on heater if it's too cold
        if (too_cold) begin
            heater = 1;
        end
    end else begin // Cooling mode
        // Turn on air conditioner if it's too hot
        if (too_hot) begin
            aircon = 1;
        end
    end

    // Turn on fan if heater or air conditioner is on, or if user requests it
    if (heater || aircon || fan_on) begin
        fan = 1;
    end
end

endmodule