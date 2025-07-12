module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    reg heater_on;
    reg aircon_on;

    always @(*) begin
        // In heating mode, turn on the heater when it's too cold
        heater_on = mode && too_cold;
        
        // In cooling mode, turn on the air conditioner when it's too hot
        aircon_on = !mode && too_hot;
        
        // Turn on the fan when the heater or air conditioner is on, or when the fan is requested
        fan = heater_on || aircon_on || fan_on;
        
        // Assign the final values to the outputs
        heater = heater_on;
        aircon = aircon_on;
    end

endmodule