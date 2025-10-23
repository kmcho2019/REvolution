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

    // Check the mode of operation
    if (mode == 1) // Heating mode
    begin
        // Check if it's too cold
        if (too_cold == 1)
        begin
            heater = 1; // Turn on the heater
        end
    end
    else // Cooling mode
    begin
        // Check if it's too hot
        if (too_hot == 1)
        begin
            aircon = 1; // Turn on the air conditioner
        end
    end

    // Check if the fan needs to be turned on
    if (heater == 1 || aircon == 1 || fan_on == 1)
    begin
        fan = 1; // Turn on the fan
    end
end

endmodule