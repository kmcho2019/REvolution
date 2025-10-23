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
    // In heating mode, turn the heater on when it is too cold
    if (mode == 1'b1 && too_cold == 1'b1) begin
        heater = 1'b1;
        aircon = 1'b0;
    // In cooling mode, turn the air conditioner on when it is too hot
    end else if (mode == 1'b0 && too_hot == 1'b1) begin
        heater = 1'b0;
        aircon = 1'b1;
    // If neither condition is met, turn both heater and air conditioner off
    end else begin
        heater = 1'b0;
        aircon = 1'b0;
    end

    // Turn the fan on when either the heater or air conditioner is on, or when the user requests it
    fan = (heater || aircon || fan_on);
end

endmodule