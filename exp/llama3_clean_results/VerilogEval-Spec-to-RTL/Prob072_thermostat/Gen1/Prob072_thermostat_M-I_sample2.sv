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
    // Initialize the outputs
    heater = 1'b0;
    aircon = 1'b0;
    fan = 1'b0;

    // In heating mode, turn on the heater if it's too cold
    if (mode && too_cold) begin
        heater = 1'b1;
    end

    // In cooling mode, turn on the air conditioner if it's too hot
    if (!mode && too_hot) begin
        aircon = 1'b1;
    end

    // Turn on the fan if the heater or air conditioner is on, or if the user requests it
    if (heater || aircon || fan_on) begin
        fan = 1'b1;
    end
end

endmodule