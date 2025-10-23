module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Direct parallel multiplexing - most efficient implementation
    assign out = sel ? b : a;

endmodule