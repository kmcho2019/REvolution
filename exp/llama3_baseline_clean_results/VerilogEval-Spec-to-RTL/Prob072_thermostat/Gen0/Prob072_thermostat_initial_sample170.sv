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
    // Initialize outputs to default values (off)
    heater = 1'b0;
    aircon = 1'b0;
    fan = 1'b0;

    // Heating mode
    if (mode == 1'b1) begin
        // Turn on heater if it's too cold
        if (too_cold == 1'b1) begin
            heater = 1'b1;
            // Turn on fan if heater is on
            fan = 1'b1;
        end
    end
    // Cooling mode
    else begin
        // Turn on air conditioner if it's too hot
        if (too_hot == 1'b1) begin
            aircon = 1'b1;
            // Turn on fan if air conditioner is on
            fan = 1'b1;
        end
    end

    // Turn on fan if user requests it, regardless of heater or air conditioner
    if (fan_on == 1'b1) begin
        fan = 1'b1;
    end
end

endmodule