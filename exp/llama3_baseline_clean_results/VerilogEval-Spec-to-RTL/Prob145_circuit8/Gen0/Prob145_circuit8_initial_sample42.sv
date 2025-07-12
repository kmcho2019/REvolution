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

always @(posedge clock) begin
    q_reg <= a || q_reg;
end

assign p = p_reg;

always @(negedge clock) begin
    if (!clock && !a)
        q_reg <= 0;
end

assign q = q_reg;

endmodule