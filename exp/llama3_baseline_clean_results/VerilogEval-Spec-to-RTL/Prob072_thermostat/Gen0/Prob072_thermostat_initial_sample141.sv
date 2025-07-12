module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(*) begin
    // In heating mode, turn on heater if it's too cold
    if (mode && too_cold) begin
        heater = 1;
        aircon = 0;
    // In cooling mode, turn on air conditioner if it's too hot
    end else if (!mode && too_hot) begin
        heater = 0;
        aircon = 1;
    // If not in heating or cooling mode, turn off both
    end else begin
        heater = 0;
        aircon = 0;
    end

    // Turn on fan if heater or air conditioner is on, or if user requests it
    fan = (heater || aircon || fan_on);
end

endmodule