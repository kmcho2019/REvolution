module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Optimal implementation using simple ternary operator
    // This provides the cleanest code while maintaining optimal PPA
    assign out = sel ? b : a;

endmodule