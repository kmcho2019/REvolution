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

always @(posedge clock or negedge clock) begin
    if (~clock) begin
        p_reg <= 0;
        q_reg <= q_reg;
    end else begin
        p_reg <= a;
        q_reg <= p_reg;
    end
end

endmodule