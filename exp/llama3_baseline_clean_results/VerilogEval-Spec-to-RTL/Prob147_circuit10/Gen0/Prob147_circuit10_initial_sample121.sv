module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    state_reg <= ~(a & state_reg) & ~(b & state_reg);
end

assign q = (b & ~state_reg) | (a & ~state_reg);

endmodule