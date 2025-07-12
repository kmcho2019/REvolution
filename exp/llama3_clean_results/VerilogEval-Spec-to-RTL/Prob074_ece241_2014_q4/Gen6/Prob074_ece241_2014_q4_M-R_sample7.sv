module TopModule(
    input clk,
    input x,
    output reg z
);

reg q_xor, q_and, q_or;

always @(posedge clk) begin
    q_xor <= x ^ q_xor;
    q_and <= x & ~q_and;
    q_or <= x | ~q_or;
end

assign z = ~( (x ^ q_xor) | (x & ~q_and) | (x | ~q_or) );

endmodule