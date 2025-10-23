module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg q_reg;
reg state_reg;

assign q = ~a & b | state_reg & ~b;
assign state = state_reg;

always @(posedge clk) begin
    state_reg <= q;
end

initial begin
    state_reg = 0;
end

endmodule