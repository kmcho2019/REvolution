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
    if (a) begin
        q_reg <= 1'b1;
    end else begin
        q_reg <= q_reg;
    end
end

assign p = p_reg;
assign q = (clock) ? q_reg : 1'b0;

endmodule