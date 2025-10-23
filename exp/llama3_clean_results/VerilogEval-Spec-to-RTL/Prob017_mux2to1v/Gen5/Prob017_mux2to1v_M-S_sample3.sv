// Module TopModule: A simplified 2-1 multiplexer.
module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,      // select line
    output [99:0] out // 100-bit output
);

// Ternary operator to select 'a' or 'b' based on 'sel'.
assign out = sel ? b : a;

endmodule