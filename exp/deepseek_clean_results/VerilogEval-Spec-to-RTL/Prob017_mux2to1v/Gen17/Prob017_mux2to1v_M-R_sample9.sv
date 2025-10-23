module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Direct parallel muxing with bitwise selection
    assign out = sel ? b : a;

endmodule