module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(*) begin
    // Heating mode: turn on heater when too cold, otherwise off
    // Cooling mode: air conditioner on when too hot, otherwise off
    heater = mode & too_cold;
    aircon = ~mode & too_hot;

    // Turn on fan when heater or air conditioner is on, or when fan_on is high
    fan = (heater | aircon) | fan_on;
end

endmodule