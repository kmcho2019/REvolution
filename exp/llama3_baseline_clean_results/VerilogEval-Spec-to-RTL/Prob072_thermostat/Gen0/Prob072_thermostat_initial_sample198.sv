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
    // In heating mode, turn on the heater if it's too cold
    if (mode == 1'b1 && too_cold == 1'b1) begin
        heater = 1'b1;
    end else begin
        heater = 1'b0;
    end
    
    // In cooling mode, turn on the air conditioner if it's too hot
    if (mode == 1'b0 && too_hot == 1'b1) begin
        aircon = 1'b1;
    end else begin
        aircon = 1'b0;
    end
    
    // Turn on the fan if the heater or air conditioner is on, or if fan_on is asserted
    if (heater == 1'b1 || aircon == 1'b1 || fan_on == 1'b1) begin
        fan = 1'b1;
    end else begin
        fan = 1'b0;
    end
end

endmodule