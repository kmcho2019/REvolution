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
        // Reset outputs
        heater = 0;
        aircon = 0;
        fan = 0;

        // In heating mode, turn on heater if it's too cold
        if (mode == 1 && too_cold == 1) begin
            heater = 1;
            fan = 1; // Turn on fan if heater is on
        end

        // In cooling mode, turn on air conditioner if it's too hot
        if (mode == 0 && too_hot == 1) begin
            aircon = 1;
            fan = 1; // Turn on fan if air conditioner is on
        end

        // Turn on fan if requested, regardless of heater and air conditioner status
        if (fan_on == 1) begin
            fan = 1;
        end
    end

endmodule