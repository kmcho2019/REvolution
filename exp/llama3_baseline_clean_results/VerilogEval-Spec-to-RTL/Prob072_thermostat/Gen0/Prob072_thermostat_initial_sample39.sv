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

    // Check the mode
    if (mode == 1) begin // Heating mode
        // Check if it's too cold
        if (too_cold == 1) begin
            heater = 1; // Turn on the heater
            fan = 1; // Turn on the fan
        end
        // Check if the fan should be turned on manually
        if (fan_on == 1) begin
            fan = 1; // Turn on the fan
        end
    end else begin // Cooling mode
        // Check if it's too hot
        if (too_hot == 1) begin
            aircon = 1; // Turn on the air conditioner
            fan = 1; // Turn on the fan
        end
        // Check if the fan should be turned on manually
        if (fan_on == 1) begin
            fan = 1; // Turn on the fan
        end
    end
    // If the fan is already on due to heating/cooling, and the user requests the fan to turn on, 
    // it will remain on. If the fan is off and the user requests it to turn on, it will turn on.
    if (fan_on == 1) begin
        fan = 1; // Turn on the fan
    end
end

endmodule