module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct 256-to-1 multiplexer implementation
    assign out = in[sel];

endmodule