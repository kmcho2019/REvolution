// Module TopModule: a 2-1 multiplexer selecting between 100-bit inputs 'a' and 'b' based on 'sel'.
module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Vectorized assignment for the output based on 'sel'.
assign out = sel ? b : a;

endmodule