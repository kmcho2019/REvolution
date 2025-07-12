module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg prev_a;
reg q_reg;

initial begin
    prev_a = 0;
    q_reg = 0;
end

always @(posedge clock) begin
    prev_a <= a;
    q_reg <= prev_a;
end

assign p = a;
assign q = q_reg;

endmodule