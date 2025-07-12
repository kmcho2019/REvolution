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
    if (mode == 1'b1) begin
        // If it's too cold, turn on the heater and fan
        if (too_cold == 1'b1) begin
            heater = 1'b1;
            fan = 1'b1;
        end
    end
    // In cooling mode
    else if (mode == 1'b0) begin
        // If it's too hot, turn on the air conditioner and fan
        if (too_hot == 1'b1) begin
            aircon = 1'b1;
            fan = 1'b1;
        end
    end

    // If the user requests the fan to turn on
    if (fan_on == 1'b1) begin
        fan = 1'b1;
    end
end

endmodule