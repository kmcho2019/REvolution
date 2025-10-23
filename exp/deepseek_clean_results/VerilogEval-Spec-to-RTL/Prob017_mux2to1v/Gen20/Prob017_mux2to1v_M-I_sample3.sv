module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Single 100-bit wide mux - simplest and most efficient implementation
    assign out = sel ? b : a;

endmodule