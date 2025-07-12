module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Simplified implementation using ternary operator
    assign out = sel ? b : a;

endmodule