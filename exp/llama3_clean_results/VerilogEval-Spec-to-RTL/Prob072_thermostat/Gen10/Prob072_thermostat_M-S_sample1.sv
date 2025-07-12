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
        heater = mode && too_cold;
        
        // In cooling mode, turn on the air conditioner when it's too hot
        aircon = !mode && too_hot;
        
        // Turn on the fan when the heater or air conditioner is on, or when the fan is requested
        fan = (mode && too_cold) || (!mode && too_hot) || fan_on;
    end

endmodule