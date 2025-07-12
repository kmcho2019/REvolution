module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    state_reg <= (state_reg && a && b) || (!state_reg && !a && !b);
end

assign q = (state_reg && !a && !b) || (!state_reg && !a && b);

endmodule