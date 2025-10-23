module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(*) begin
    // Initialize outputs to 0
    heater = 0;
    aircon = 0;
    fan = 0;

    // Check if we are in heating mode
    if (mode) begin
        // If it's too cold, turn on the heater and fan
        if (too_cold) begin
            heater = 1;
            fan = 1;
        end
    end
    // If we are not in heating mode, we are in cooling mode
    else begin
        // If it's too hot, turn on the air conditioner and fan
        if (too_hot) begin
            aircon = 1;
            fan = 1;
        end
    end

    // Turn on the fan if requested
    if (fan_on) begin
        fan = 1;
    end
end

endmodule