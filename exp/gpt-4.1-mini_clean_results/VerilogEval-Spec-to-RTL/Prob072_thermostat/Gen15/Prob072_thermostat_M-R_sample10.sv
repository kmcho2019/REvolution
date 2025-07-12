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
        // Heater is on only in heating mode when too cold
        heater = (mode == 1'b1) && (too_cold == 1'b1);
        // Aircon is on only in cooling mode when too hot
        aircon = (mode == 1'b0) && (too_hot == 1'b1);
        // Fan is on if heater or aircon are on, or if user requests fan on
        fan = heater | aircon | fan_on;
    end

endmodule