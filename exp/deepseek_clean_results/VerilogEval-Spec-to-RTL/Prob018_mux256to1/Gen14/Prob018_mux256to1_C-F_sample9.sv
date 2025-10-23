module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct bit selection using concatenation
    // This creates a balanced path through the multiplexer
    assign out = in[sel];

endmodule