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
    // Initialize all outputs to 0
    heater = 0;
    aircon = 0;
    fan = 0;

    // In heating mode, turn on heater when it's too cold
    if (mode && too_cold) begin
        heater = 1;
    end

    // In cooling mode, turn on air conditioner when it's too hot
    if (!mode && too_hot) begin
        aircon = 1;
    end

    // Turn on fan if heater or air conditioner is on, or if fan is requested
    if (heater || aircon || fan_on) begin
        fan = 1;
    end
end

endmodule