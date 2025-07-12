module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;

always @(posedge clk) begin
    state_reg <= a ^ b;
end

assign state = state_reg;
assign q = state_reg ^ b;

endmodule