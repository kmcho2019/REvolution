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
    // Default states
    heater = 0;
    aircon = 0;
    fan = 0;

    // Check the mode
    if (mode) begin // Heating mode
        // Check if it is too cold
        if (too_cold) begin
            heater = 1;
            fan = 1; // Turn on the fan when the heater is on
        end
    end else begin // Cooling mode
        // Check if it is too hot
        if (too_hot) begin
            aircon = 1;
            fan = 1; // Turn on the fan when the air conditioner is on
        end
    end

    // Check if the user wants the fan on
    if (fan_on) begin
        fan = 1;
    end
end

endmodule