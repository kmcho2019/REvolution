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
    // Initialize outputs to default values
    heater = 0;
    aircon = 0;
    fan = 0;

    // In heating mode, turn on the heater if it's too cold
    if (mode == 1) begin
        if (too_cold == 1) begin
            heater = 1;
        end
    end
    // In cooling mode, turn on the air conditioner if it's too hot
    else if (mode == 0) begin
        if (too_hot == 1) begin
            aircon = 1;
        end
    end

    // Turn on the fan if the heater or air conditioner is on, or if fan_on is high
    if (heater == 1 || aircon == 1 || fan_on == 1) begin
        fan = 1;
    end
end

endmodule