module TopModule (
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

    // Heating mode
    if (mode) begin
        // Turn heater on when it's too cold
        if (too_cold) begin
            heater = 1;
            // Turn fan on when heater is on
            fan = 1;
        end
        // Turn fan on when user requests it
        if (fan_on) begin
            fan = 1;
        end
    end
    // Cooling mode
    else begin
        // Turn air conditioner on when it's too hot
        if (too_hot) begin
            aircon = 1;
            // Turn fan on when air conditioner is on
            fan = 1;
        end
        // Turn fan on when user requests it
        if (fan_on) begin
            fan = 1;
        end
    end
end

endmodule