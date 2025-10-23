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
    // Initialize outputs to 0
    heater = 0;
    aircon = 0;
    fan = 0;

    // In heating mode
    if (mode) begin
        // Turn on heater if too cold
        if (too_cold) begin
            heater = 1;
            fan = 1;
        end
    end
    // In cooling mode
    else begin
        // Turn on air conditioner if too hot
        if (too_hot) begin
            aircon = 1;
            fan = 1;
        end
    end

    // Turn on fan if fan_on is asserted
    if (fan_on) begin
        fan = 1;
    end
end

endmodule