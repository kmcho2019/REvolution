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
    // Reset all outputs to 0
    heater = 0;
    aircon = 0;
    fan = 0;

    // Determine the current mode of operation
    if (mode == 1'b1) // Heating mode
    begin
        if (too_cold == 1'b1)
        begin
            heater = 1'b1; // Turn on the heater
            fan = 1'b1; // Turn on the fan to circulate air
        end
    end
    else // Cooling mode
    begin
        if (too_hot == 1'b1)
        begin
            aircon = 1'b1; // Turn on the air conditioner
            fan = 1'b1; // Turn on the fan to circulate air
        end
    end

    // Turn on the fan if requested by the user
    if (fan_on == 1'b1)
    begin
        fan = 1'b1;
    end
end

endmodule