module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Direct 256-to-1 mux using continuous assignment and vector indexing
    assign out = in[sel];
endmodule