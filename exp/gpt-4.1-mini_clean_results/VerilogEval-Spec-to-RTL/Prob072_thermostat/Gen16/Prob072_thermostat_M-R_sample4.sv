module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @(*) begin
        // Default outputs to 0
        heater = 1'b0;
        aircon = 1'b0;
        fan = 1'b0;

        if (mode) begin
            // Heating mode
            if (too_cold)
                heater = 1'b1;
        end else begin
            // Cooling mode
            if (too_hot)
                aircon = 1'b1;
        end

        // Fan on if heater or aircon is on or user requested
        fan = heater | aircon | fan_on;
    end

endmodule