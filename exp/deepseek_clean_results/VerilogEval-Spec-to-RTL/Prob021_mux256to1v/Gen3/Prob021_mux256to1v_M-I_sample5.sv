module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Single-stage 256:1 mux with optimized bit selection
    // sel*4 is equivalent to {sel, 2'b00}
    assign out = in[{sel, 2'b00} +: 4];

endmodule