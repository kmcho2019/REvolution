module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    always @(mode, too_cold, too_hot, fan_on) begin
        // Initialize outputs to 0
        heater = 0;
        aircon = 0;
        fan = 0;

        // Check mode
        if (mode == 1) begin // Heating mode
            // Check if it's too cold
            if (too_cold == 1) begin
                heater = 1;
                fan = 1;
            end
        end else begin // Cooling mode
            // Check if it's too hot
            if (too_hot == 1) begin
                aircon = 1;
                fan = 1;
            end
        end

        // Check if fan should be turned on regardless of heater and air conditioner
        if (fan_on == 1) begin
            fan = 1;
        end
    end

endmodule