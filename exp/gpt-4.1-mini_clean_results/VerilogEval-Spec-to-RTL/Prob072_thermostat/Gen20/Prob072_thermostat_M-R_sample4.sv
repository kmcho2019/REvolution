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
        if (mode) begin
            // Heating mode: Heater on if too cold
            heater = too_cold;
            aircon = 1'b0;
        end else begin
            // Cooling mode: Aircon on if too hot
            heater = 1'b0;
            aircon = too_hot;
        end
        // Fan on if heater or aircon on, or fan_on input asserted
        fan = heater | aircon | fan_on;
    end

endmodule