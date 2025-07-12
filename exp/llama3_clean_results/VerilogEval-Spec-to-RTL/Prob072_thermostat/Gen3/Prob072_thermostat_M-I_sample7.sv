// No significant changes are needed in the Verilog code itself as the existing implementation is already quite optimized.
// However, to potentially improve PPA metrics, it's crucial to work with the synthesis tool's settings and ensure the most efficient resources are used.
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
    heater = mode && too_cold;
    aircon = ~mode && too_hot;
    fan = fan_on || heater || aircon;
end

endmodule