// Module TopModule implements a 2-1 multiplexer.
module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use a vectorized assignment for the entire output.
assign out = sel? b : a;

endmodule