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

    // Check mode and temperature conditions
    if (mode == 1'b1) begin // Heating mode
        if (too_cold == 1'b1) begin
            heater = 1'b1; // Turn on heater
            fan = 1'b1; // Turn on fan
        end
    end else begin // Cooling mode
        if (too_hot == 1'b1) begin
            aircon = 1'b1; // Turn on air conditioner
            fan = 1'b1; // Turn on fan
        end
    end

    // Turn on fan if requested by user
    if (fan_on == 1'b1) begin
        fan = 1'b1;
    end
end

endmodule