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

always @(posedge clock) begin
    p_reg <= a;
    q_reg <= (a == 1) ? 1 : q_reg;
end

always @(negedge clock) begin
    q_reg <= q_reg;
end

initial begin
    p_reg = 0;
    q_reg = 0;
end

endmodule