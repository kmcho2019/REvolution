module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg q_reg;
reg p_prev;

assign p = clock & a;

always @(negedge clock) begin
    if (p_prev) begin
        q_reg <= ~q_reg;
    end
    p_prev <= p;
end

assign q = q_reg;

endmodule