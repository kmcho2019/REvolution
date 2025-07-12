module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct indexing - synthesis tool will implement optimal structure
    // (hierarchical 16x16 or other optimized implementation)
    assign out = in[sel];

endmodule