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
    if (mode == 1) begin
        // Turn on heater if too cold
        if (too_cold == 1) begin
            heater = 1;
            fan = 1; // Turn on fan to circulate air
        end
    end
    // In cooling mode
    else if (mode == 0) begin
        // Turn on air conditioner if too hot
        if (too_hot == 1) begin
            aircon = 1;
            fan = 1; // Turn on fan to circulate air
        end
    end

    // Turn on fan if requested by user, even if heater and air conditioner are off
    if (fan_on == 1) begin
        fan = 1;
    end
end

endmodule