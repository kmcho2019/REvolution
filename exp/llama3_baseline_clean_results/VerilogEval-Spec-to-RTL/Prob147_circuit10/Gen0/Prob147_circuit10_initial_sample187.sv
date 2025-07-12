module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;

always @(posedge clk) begin
    state_reg <= b || (state_reg && !a);
end

assign state = state_reg;
assign q = b || (!state_reg && b);

endmodule