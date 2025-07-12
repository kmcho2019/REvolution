module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    always @(*) begin
        // Initialize outputs to 0
        heater = 0;
        aircon = 0;
        fan = 0;

        // Heating mode
        if (mode == 1) begin
            if (too_cold == 1) begin
                heater = 1;
            end
            if (heater == 1 || fan_on == 1) begin
                fan = 1;
            end
        end
        // Cooling mode
        else if (mode == 0) begin
            if (too_hot == 1) begin
                aircon = 1;
            end
            if (aircon == 1 || fan_on == 1) begin
                fan = 1;
            end
        end
    end

endmodule