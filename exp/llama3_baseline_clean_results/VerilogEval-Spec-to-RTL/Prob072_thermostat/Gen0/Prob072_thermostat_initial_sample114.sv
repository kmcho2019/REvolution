module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    always @(*) begin
        // Initialize outputs to default values (off)
        heater = 1'b0;
        aircon = 1'b0;
        fan = 1'b0;

        // Check the mode
        if (mode) begin
            // Heating mode
            if (too_cold) begin
                heater = 1'b1; // Turn on heater
                fan = 1'b1; // Turn on fan
            end
        end else begin
            // Cooling mode
            if (too_hot) begin
                aircon = 1'b1; // Turn on air conditioner
                fan = 1'b1; // Turn on fan
            end
        end

        // Turn on fan if fan_on is high, regardless of other conditions
        if (fan_on) begin
            fan = 1'b1;
        end
    end

endmodule