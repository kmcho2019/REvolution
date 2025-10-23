module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    always @(mode, too_cold, too_hot, fan_on) begin
        // Initialize outputs to 0
        heater = 0;
        aircon = 0;
        fan = 0;

        // Check the mode
        if (mode == 1) begin // Heating mode
            // Check if it's too cold
            if (too_cold == 1) begin
                // Turn on the heater and fan
                heater = 1;
                fan = 1;
            end
        end else begin // Cooling mode
            // Check if it's too hot
            if (too_hot == 1) begin
                // Turn on the air conditioner and fan
                aircon = 1;
                fan = 1;
            end
        end

        // Check if the user wants the fan to turn on
        if (fan_on == 1) begin
            // Turn on the fan regardless of the heater and air conditioner status
            fan = 1;
        end
    end

endmodule