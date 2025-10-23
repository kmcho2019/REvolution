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
    // Initialize the outputs to 0
    heater = 0;
    aircon = 0;
    fan = 0;

    // In heating mode, turn on the heater when it is too cold
    if (mode == 1'b1 && too_cold == 1'b1)
    begin
        heater = 1'b1;
        fan = 1'b1; // Turn on the fan when the heater is on
    end

    // In cooling mode, turn on the air conditioner when it is too hot
    if (mode == 1'b0 && too_hot == 1'b1)
    begin
        aircon = 1'b1;
        fan = 1'b1; // Turn on the fan when the air conditioner is on
    end

    // Turn on the fan if requested, even if the heater and air conditioner are off
    if (fan_on == 1'b1)
    begin
        fan = 1'b1;
    end
end

endmodule