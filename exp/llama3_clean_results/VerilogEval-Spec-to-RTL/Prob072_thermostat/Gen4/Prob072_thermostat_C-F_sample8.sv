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
    // In heating mode, turn the heater on when it's too cold
    heater = mode && too_cold;
    
    // In cooling mode, turn the air conditioner on when it's too hot
    aircon = ~mode && too_hot;
    
    // Turn the fan on when the heater or air conditioner is on, or if fan_on is asserted
    fan = (heater || aircon) || fan_on;
end

endmodule