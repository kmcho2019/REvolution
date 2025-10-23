module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Direct implementation using ternary operator
    // This is both clean and optimally synthesizable
    assign out = sel ? b : a;

endmodule