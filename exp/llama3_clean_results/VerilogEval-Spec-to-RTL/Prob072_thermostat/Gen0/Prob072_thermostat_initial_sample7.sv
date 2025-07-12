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
    // In heating mode, turn on the heater when it's too cold
    if (mode == 1'b1 && too_cold == 1'b1) begin
        heater = 1'b1;
        aircon = 1'b0;
    // In cooling mode, turn on the air conditioner when it's too hot
    end else if (mode == 1'b0 && too_hot == 1'b1) begin
        heater = 1'b0;
        aircon = 1'b1;
    // If neither condition is met, turn off the heater and air conditioner
    end else begin
        heater = 1'b0;
        aircon = 1'b0;
    end

    // Turn on the fan if either the heater or air conditioner is on, or if the user requests it
    if (heater == 1'b1 || aircon == 1'b1 || fan_on == 1'b1) begin
        fan = 1'b1;
    end else begin
        fan = 1'b0;
    end
end

endmodule