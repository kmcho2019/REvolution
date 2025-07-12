module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_reg;

always @(posedge clock) begin
    q_reg <= a;
end

assign p = clock & a;
assign q = q_reg;

endmodule