module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg, q_reg;

initial begin
    p_reg = 1'b0;
    q_reg = 1'b0;
end

always @(posedge clock) begin
    p_reg <= a;
    q_reg <= p_reg;
end

assign p = p_reg;
assign q = q_reg;

endmodule