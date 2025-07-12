module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @(*) begin
        // Default outputs off
        heater = 1'b0;
        aircon = 1'b0;
        fan = 1'b0;

        if (mode) begin // Heating mode
            if (too_cold) begin
                heater = 1'b1;
                fan = 1'b1;
            end else begin
                // Heater off, but fan may still be on due to fan_on
                fan = fan_on;
            end
            // aircon remains off in heating mode
        end else begin // Cooling mode
            if (too_hot) begin
                aircon = 1'b1;
                fan = 1'b1;
            end else begin
                // Aircon off, fan controlled by fan_on only
                fan = fan_on;
            end
            // heater remains off in cooling mode
        end
        // If heater or aircon already turned fan on, fan_on has no further effect
        // but this is covered by setting fan=1 in those cases above.
        // Alternatively, ensure fan is on if either fan_on or heater/aircon is on:
        if (heater == 1'b0 && aircon == 1'b0) begin
            fan = fan_on;
        end
    end

endmodule