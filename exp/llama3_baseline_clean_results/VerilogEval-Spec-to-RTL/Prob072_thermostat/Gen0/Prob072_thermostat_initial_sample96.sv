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

    // Check mode to determine whether we are in heating or cooling mode
    if (mode) begin // Heating mode
        if (too_cold) begin
            heater = 1; // Turn on heater if too cold
            fan = 1; // Turn on fan
        end
    end else begin // Cooling mode
        if (too_hot) begin
            aircon = 1; // Turn on air conditioner if too hot
            fan = 1; // Turn on fan
        end
    end

    // Turn on fan if fan_on is 1
    if (fan_on) begin
        fan = 1;
    end
end

endmodule