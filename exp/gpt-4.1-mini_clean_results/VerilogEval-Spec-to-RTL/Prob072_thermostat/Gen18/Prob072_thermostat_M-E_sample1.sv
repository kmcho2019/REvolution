module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @(*) begin
        // Default all outputs off
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

        // Fan is on if heater or aircon are on or if user requested fan_on
        if (heater || aircon || fan_on)
            fan = 1'b1;
    end

endmodule