module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(*)
begin
    // Initialize outputs
    heater = 0;
    aircon = 0;
    fan = 0;

    // Check mode and temperature conditions
    if (mode == 1'b1 && too_cold == 1'b1) // Heating mode and too cold
    begin
        heater = 1'b1; // Turn on heater
    end
    else if (mode == 1'b0 && too_hot == 1'b1) // Cooling mode and too hot
    begin
        aircon = 1'b1; // Turn on air conditioner
    end

    // Turn on fan if heater or air conditioner is on, or if fan is requested
    if (heater == 1'b1 || aircon == 1'b1 || fan_on == 1'b1)
    begin
        fan = 1'b1; // Turn on fan
    end
end

endmodule