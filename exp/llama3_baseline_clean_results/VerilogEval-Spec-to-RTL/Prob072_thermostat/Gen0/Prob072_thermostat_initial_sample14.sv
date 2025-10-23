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
    // Heater is on in heating mode if it is too cold
    heater = mode && too_cold;
    
    // Air conditioner is on in cooling mode if it is too hot
    aircon = ~mode && too_hot;
    
    // Fan is on if either heater or air conditioner is on, or if fan_on is 1
    fan = (mode && too_cold) || (~mode && too_hot) || fan_on;
end

endmodule