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
        // Initialize outputs to default values
        heater = 1'b0;
        aircon = 1'b0;
        fan = 1'b0;

        // Check mode and temperature conditions
        if (mode == 1'b1) begin // Heating mode
            if (too_cold == 1'b1) begin
                heater = 1'b1;
            end
        end else begin // Cooling mode
            if (too_hot == 1'b1) begin
                aircon = 1'b1;
            end
        end

        // Turn on fan if heater or air conditioner is on
        if (heater == 1'b1 || aircon == 1'b1) begin
            fan = 1'b1;
        end else if (fan_on == 1'b1) begin // Turn on fan if user requests
            fan = 1'b1;
        end
    end

endmodule