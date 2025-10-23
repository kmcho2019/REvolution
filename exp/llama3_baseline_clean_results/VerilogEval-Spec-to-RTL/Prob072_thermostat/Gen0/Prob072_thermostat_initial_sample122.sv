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
    // Initialize outputs to off state
    heater = 0;
    aircon = 0;
    fan = 0;

    // Check the mode and conditions to control the outputs
    if (mode == 1) begin // Heating mode
        if (too_cold == 1) begin
            heater = 1; // Turn on heater if too cold
            fan = 1; // Turn on fan to circulate air
        end
    end else begin // Cooling mode
        if (too_hot == 1) begin
            aircon = 1; // Turn on air conditioner if too hot
            fan = 1; // Turn on fan to circulate air
        end
    end

    // Turn on fan if requested by user, regardless of heater and air conditioner state
    if (fan_on == 1) begin
        fan = 1;
    end
end

endmodule