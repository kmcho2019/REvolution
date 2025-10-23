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
    if (mode) begin
        // Heating mode
        heater = too_cold;
        aircon = 1'b0;
    end else begin
        // Cooling mode
        heater = 1'b0;
        aircon = too_hot;
    end

    // Fan runs if heater or aircon is on, or if fan_on is requested
    fan = heater | aircon | fan_on;
end

endmodule