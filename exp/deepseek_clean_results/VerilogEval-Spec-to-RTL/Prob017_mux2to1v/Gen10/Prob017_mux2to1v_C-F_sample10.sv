module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Optimal implementation using direct ternary operator
    assign out = sel ? b : a;

endmodule