module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

always @(posedge clock) begin
    p_reg <= a;
end

always @(negedge clock) begin
    q_reg <= p_reg;
end

assign p = p_reg;
assign q = q_reg;

endmodule