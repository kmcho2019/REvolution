module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    always @(*) begin
        // Initialize outputs to 0
        heater = 0;
        aircon = 0;
        fan = 0;

        // In heating mode
        if (mode == 1) begin
            // Turn on heater if it's too cold
            if (too_cold == 1) begin
                heater = 1;
                // Turn on fan if heater is on
                fan = 1;
            end
            // Turn on fan if requested
            if (fan_on == 1) begin
                fan = 1;
            end
        end
        // In cooling mode
        else if (mode == 0) begin
            // Turn on air conditioner if it's too hot
            if (too_hot == 1) begin
                aircon = 1;
                // Turn on fan if air conditioner is on
                fan = 1;
            end
            // Turn on fan if requested
            if (fan_on == 1) begin
                fan = 1;
            end
        end
    end

endmodule