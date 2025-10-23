module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Hierarchical 256-to-1 mux:
    // - sel[3:0] selects within 16-bit group (stage 1)
    // - sel[7:4] selects which group (stage 2)
    assign out = in[{sel[7:4], sel[3:0]}];

endmodule