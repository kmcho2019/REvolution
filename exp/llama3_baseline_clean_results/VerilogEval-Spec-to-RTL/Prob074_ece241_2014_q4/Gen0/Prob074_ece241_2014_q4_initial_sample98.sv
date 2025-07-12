module TopModule(
    input clk,
    input x,
    output z
);

reg q_xor, q_and, q_or;

always @(posedge clk) begin
    q_xor <= x ^ q_xor;
    q_and <= x & ~q_and;
    q_or <= x | ~q_or;
end

assign z = ~(q_xor | q_and | q_or);

endmodule