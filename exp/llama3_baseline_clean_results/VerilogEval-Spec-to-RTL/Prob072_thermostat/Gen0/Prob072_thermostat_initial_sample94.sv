module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(*)
begin
    // In heating mode, turn the heater on when it is too cold
    if (mode) 
    begin
        heater = too_cold;
        aircon = 1'b0;
    end 
    // In cooling mode, turn the air conditioner on when it is too hot
    else 
    begin
        heater = 1'b0;
        aircon = too_hot;
    end

    // Turn on the fan when the heater or air conditioner are on, or when fan_on is 1
    fan = (heater | aircon | fan_on);
end

endmodule