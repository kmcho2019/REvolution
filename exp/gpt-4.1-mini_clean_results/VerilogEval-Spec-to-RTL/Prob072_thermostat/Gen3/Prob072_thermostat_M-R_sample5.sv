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
    // Determine heating and cooling conditions
    heater = mode & too_cold;
    aircon = (~mode) & too_hot;

    // Fan is on if heater or aircon is on, or if user requests fan
    fan = heater | aircon | fan_on;
end

endmodule