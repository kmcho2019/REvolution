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
    // Initialize outputs to 0
    heater = 0;
    aircon = 0;
    fan = 0;

    // Mode is 1 (heating)
    if (mode) begin
        // Turn on heater if it's too cold
        if (too_cold) begin
            heater = 1;
            fan = 1; // Turn on fan when heater is on
        end
    end
    // Mode is 0 (cooling)
    else begin
        // Turn on air conditioner if it's too hot
        if (too_hot) begin
            aircon = 1;
            fan = 1; // Turn on fan when air conditioner is on
        end
    end

    // Turn on fan if requested, regardless of heating/cooling mode
    if (fan_on) begin
        fan = 1;
    end
end

endmodule