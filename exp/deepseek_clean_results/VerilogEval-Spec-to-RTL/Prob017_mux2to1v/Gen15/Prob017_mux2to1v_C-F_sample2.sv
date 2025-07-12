module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Optimal fused implementation:
    // - Single conditional operator for parallel computation
    // - No intermediate wires or hierarchy
    // - Clean and efficient
    assign out = sel ? b : a;

endmodule