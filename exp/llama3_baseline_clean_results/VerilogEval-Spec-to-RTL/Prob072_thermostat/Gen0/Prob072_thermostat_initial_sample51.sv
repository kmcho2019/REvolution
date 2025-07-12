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

    // In heating mode, turn on heater if it's too cold
    if (mode == 1 && too_cold == 1) begin
        heater = 1;
    end

    // In cooling mode, turn on air conditioner if it's too hot
    if (mode == 0 && too_hot == 1) begin
        aircon = 1;
    end

    // Turn on fan if heater or air conditioner is on, or if user requests it
    if (heater == 1 || aircon == 1 || fan_on == 1) begin
        fan = 1;
    end
end

endmodule