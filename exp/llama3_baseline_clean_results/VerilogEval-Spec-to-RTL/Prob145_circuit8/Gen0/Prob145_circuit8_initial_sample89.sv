module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
assign p = (clock) ? a : 0;
assign q = (~clock) ? p_reg : p;

always @(posedge clock) begin
    p_reg <= a;
end

endmodule