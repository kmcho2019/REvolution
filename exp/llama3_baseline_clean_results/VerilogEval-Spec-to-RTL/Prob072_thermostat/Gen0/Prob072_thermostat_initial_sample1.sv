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
    // Reset the outputs to default values
    heater = 0;
    aircon = 0;
    fan = 0;

    // Turn on the heater when in heating mode and it's too cold
    if (mode && too_cold) begin
        heater = 1;
    end

    // Turn on the air conditioner when in cooling mode and it's too hot
    if (!mode && too_hot) begin
        aircon = 1;
    end

    // Turn on the fan when the heater or air conditioner is on, or when the user requests it
    if (heater || aircon || fan_on) begin
        fan = 1;
    end
end

endmodule