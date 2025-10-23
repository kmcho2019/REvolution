module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;
reg q_x, q_a, q_o;

always @(posedge clk) begin
    q_x <= xor_out;
    q_a <= and_out;
    q_o <= or_out;
end

assign xor_out = x ^ q_x;
assign and_out = x & ~q_a;
assign or_out = x | ~q_o;

assign z = ~(xor_out | and_out | or_out);

initial begin
    q_x = 0;
    q_a = 0;
    q_o = 0;
end

endmodule