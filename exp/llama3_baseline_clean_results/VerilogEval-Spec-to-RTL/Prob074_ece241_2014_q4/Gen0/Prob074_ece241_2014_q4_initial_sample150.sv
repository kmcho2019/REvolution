module TopModule(
    input clk,
    input x,
    output z
);

reg q_xor, q_and, q_or;

assign z = ~(q_xor | q_and | q_or);

always @(posedge clk) begin
    q_xor <= x ^ q_xor;
    q_and <= x & ~q_and;
    q_or <= x | ~q_or;
end

initial begin
    q_xor = 0;
    q_and = 0;
    q_or = 0;
end

endmodule