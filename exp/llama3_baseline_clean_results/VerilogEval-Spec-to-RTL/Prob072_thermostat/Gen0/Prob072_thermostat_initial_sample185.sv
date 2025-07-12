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

    // If mode is 1 (heating), turn on heater if too cold
    if (mode == 1 && too_cold == 1) begin
        heater = 1;
    end

    // If mode is 0 (cooling), turn on air conditioner if too hot
    if (mode == 0 && too_hot == 1) begin
        aircon = 1;
    end

    // Turn on fan if heater or air conditioner is on, or if fan_on is 1
    if (heater == 1 || aircon == 1 || fan_on == 1) begin
        fan = 1;
    end
end

endmodule