module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;
reg q_xor, q_and, q_or;

assign z = ~(xor_out | and_out | or_out);

always @(*) begin
    xor_out = x ^ q_xor;
    and_out = x & ~q_and;
    or_out = x | ~q_or;
end

always @(posedge clk) begin
    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
end

initial begin
    q_xor = 0;
    q_and = 0;
    q_or = 0;
end

endmodule