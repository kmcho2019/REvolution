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
    // Initialize outputs to off
    heater = 1'b0;
    aircon = 1'b0;
    fan = 1'b0;

    // Determine the mode (heating or cooling) and check temperature conditions
    if (mode == 1'b1) begin // heating mode
        if (too_cold == 1'b1) begin
            heater = 1'b1; // turn on heater
        end
    end else begin // cooling mode
        if (too_hot == 1'b1) begin
            aircon = 1'b1; // turn on air conditioner
        end
    end

    // Turn on fan if heater or air conditioner is on, or if user requests it
    if (heater == 1'b1 || aircon == 1'b1 || fan_on == 1'b1) begin
        fan = 1'b1; // turn on fan
    end
end

endmodule