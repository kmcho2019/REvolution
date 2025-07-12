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
    if (mode) begin
        heater = too_cold;
        aircon = 0;
    end
    // In cooling mode, turn on the air conditioner if it's too hot
    else begin
        heater = 0;
        aircon = too_hot;
    end
    
    // Turn on the fan if the heater or air conditioner is on, or if the fan is requested
    fan = (heater || aircon || fan_on);
end

endmodule