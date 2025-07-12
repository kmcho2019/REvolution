module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_out, and_out, or_out;
reg q_xor, q_and, q_or;

// D Flip-Flops
always @(posedge clk) begin
    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
end

// Gates
assign xor_out = x ^ q_xor;
assign and_out = x & ~q_and;
assign or_out = x | ~q_or;

// Final NOR Gate
assign z = ~(q_xor | q_and | q_or);

endmodule