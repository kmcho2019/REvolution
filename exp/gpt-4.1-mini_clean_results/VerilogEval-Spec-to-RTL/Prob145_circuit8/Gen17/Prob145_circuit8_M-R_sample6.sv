module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

assign p = p_reg;
assign q = q_reg;

initial begin
    p_reg = 1'bx;
    q_reg = 1'bx;
end

always @(posedge clock) begin
    q_reg <= p_reg;
    if (q_reg == 1'b0)
        p_reg <= a;
    else
        p_reg <= p_reg;
end

endmodule