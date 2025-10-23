module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

always @(*)
begin
    // Initialize heater and air conditioner to off
    heater = 1'b0;
    aircon = 1'b0;

    // Check the mode of operation
    if (mode == 1'b1) // Heating mode
    begin
        // Turn heater on if it's too cold
        if (too_cold == 1'b1)
        begin
            heater = 1'b1;
        end
    end
    else // Cooling mode
    begin
        // Turn air conditioner on if it's too hot
        if (too_hot == 1'b1)
        begin
            aircon = 1'b1;
        end
    end

    // Turn fan on if heater or air conditioner is on, or if user requests it
    fan = (heater || aircon) || fan_on;
end

endmodule