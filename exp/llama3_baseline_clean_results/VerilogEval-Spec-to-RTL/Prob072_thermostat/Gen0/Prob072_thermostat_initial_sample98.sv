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
    // In heating mode, turn on heater when it's too cold
    if (mode) begin
        heater = too_cold;
        aircon = 0;
    end
    // In cooling mode, turn on air conditioner when it's too hot
    else begin
        heater = 0;
        aircon = too_hot;
    end

    // Turn on fan when either heater or air conditioner is on, or when user requests it
    fan = (heater || aircon) || fan_on;
end

endmodule