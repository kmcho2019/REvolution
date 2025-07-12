module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg, q_reg;

always @(posedge clock) begin
    p_reg <= (q_reg == 1'b0) ? a : (a ? 1'b1 : 1'b0);
    q_reg <= p_reg;
end

assign p = p_reg;
assign q = q_reg;

initial begin
    p_reg = 1'b0;
    q_reg = 1'b0;
end

endmodule