// Refactored TopModule using vector assignment with a conditional operator.
module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use a vector assignment to select between 'a' and 'b' based on 'sel'.
assign out = (sel)? b : a;

endmodule