module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;
reg prev_p;

always @(posedge clock) begin
    p_reg <= a;
    prev_p <= p_reg;
    
    if (prev_p && p_reg) begin
        q_reg <= ~q_reg;
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule