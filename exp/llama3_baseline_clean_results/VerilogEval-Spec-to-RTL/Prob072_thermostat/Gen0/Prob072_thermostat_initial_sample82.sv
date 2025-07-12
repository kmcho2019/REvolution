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
    // Turn heater on when in heating mode and too cold
    heater = mode & too_cold;

    // Turn air conditioner on when in cooling mode and too hot
    aircon = ~mode & too_hot;

    // Turn fan on when heater or air conditioner is on, or when user requests it
    fan = heater | aircon | fan_on;
end

endmodule