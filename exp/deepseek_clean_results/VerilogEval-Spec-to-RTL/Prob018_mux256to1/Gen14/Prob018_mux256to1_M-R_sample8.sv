module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct 256:1 mux using bit selection
    assign out = in[sel];

endmodule