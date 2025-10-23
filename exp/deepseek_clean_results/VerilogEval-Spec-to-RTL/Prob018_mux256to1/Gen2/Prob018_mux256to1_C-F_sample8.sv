module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct indexing allows synthesis tool to choose optimal implementation
    assign out = in[sel];

endmodule