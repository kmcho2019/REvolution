module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;

assign q = (a & ~state_reg) | (b & ~a & state_reg);
assign state = state_reg;

always @(posedge clk) begin
    state_reg <= q;
end

endmodule