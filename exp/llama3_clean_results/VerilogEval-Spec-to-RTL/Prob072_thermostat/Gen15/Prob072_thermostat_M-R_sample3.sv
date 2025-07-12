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
        heater = (mode && too_cold) ? 1 : 0;
        
        // In cooling mode, turn on the air conditioner when it's too hot
        aircon = (!mode && too_hot) ? 1 : 0;
        
        // Turn on the fan when the heater or air conditioner is on, or when the fan is requested
        fan = (heater || aircon || fan_on) ? 1 : 0;
    end

endmodule