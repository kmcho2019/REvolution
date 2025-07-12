// Module TopModule: A 2-1 multiplexer selecting between 100-bit inputs 'a' and 'b' based on 'sel'.
module TopModule(
    input  [99:0] a,  // 100-bit input vector a
    input  [99:0] b,  // 100-bit input vector b
    input  sel,       // 1-bit select input
    output [99:0] out // 100-bit output vector out
);

// Conditionally assign 'out' based on 'sel' using a ternary operator.
assign out = sel ? b : a;

endmodule