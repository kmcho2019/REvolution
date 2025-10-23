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
    // Turn on heater when mode is heating and it's too cold
    heater = mode && too_cold;
    
    // Turn on air conditioner when mode is cooling and it's too hot
    aircon = ~mode && too_hot;
    
    // Turn on fan when heater or air conditioner is on, or when user requests it
    fan = (heater || aircon) || fan_on;
end

endmodule