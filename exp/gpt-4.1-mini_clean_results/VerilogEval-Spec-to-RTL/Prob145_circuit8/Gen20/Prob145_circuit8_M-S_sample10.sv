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
    if (p_reg === 1'bx)
        p_reg <= a;         // On first clock, p takes a directly
    else
        p_reg <= p_reg | a; // Accumulate p with a over time
end

endmodule