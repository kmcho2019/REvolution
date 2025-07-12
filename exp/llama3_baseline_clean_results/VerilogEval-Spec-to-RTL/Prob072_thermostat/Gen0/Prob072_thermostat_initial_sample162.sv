module TopModule(
    input  mode,       // 1 for heating, 0 for cooling
    input  too_cold,   // 1 if temperature is too cold
    input  too_hot,    // 1 if temperature is too hot
    input  fan_on,     // 1 to request fan on
    output heater,     // 1 to turn on heater
    output aircon,     // 1 to turn on air conditioner
    output fan         // 1 to turn on fan
);

    always @(*) begin
        // Initialize outputs to default values
        heater = 0;
        aircon = 0;
        fan = 0;

        // Check mode and temperature to control heater and air conditioner
        if (mode == 1) begin  // Heating mode
            if (too_cold == 1) begin
                heater = 1;
                fan = 1;  // Turn on fan when heater is on
            end
        end else begin  // Cooling mode
            if (too_hot == 1) begin
                aircon = 1;
                fan = 1;  // Turn on fan when air conditioner is on
            end
        end

        // Turn on fan if user requests it, even if heater and air conditioner are off
        if (fan_on == 1) begin
            fan = 1;
        end
    end

endmodule