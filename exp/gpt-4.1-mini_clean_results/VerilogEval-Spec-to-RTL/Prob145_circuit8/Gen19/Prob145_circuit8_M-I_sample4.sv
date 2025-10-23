module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg p_reg, q_reg, p_d;

always @(posedge clock) begin
    p_reg <= a & q_reg; // p <= a & q
    p_d <= p_reg;       // delayed p to simulate q update on falling edge
    q_reg <= p_d;       // q <= delayed p
end

assign p = p_reg;
assign q = q_reg;

endmodule