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
        // Heater on only in heating mode when too cold
        if (mode && too_cold)
            heater = 1'b1;
        else
            heater = 1'b0;

        // Aircon on only in cooling mode when too hot
        if (~mode && too_hot)
            aircon = 1'b1;
        else
            aircon = 1'b0;

        // Fan on if heater, aircon, or fan_on is active
        if (heater || aircon || fan_on)
            fan = 1'b1;
        else
            fan = 1'b0;
    end

endmodule