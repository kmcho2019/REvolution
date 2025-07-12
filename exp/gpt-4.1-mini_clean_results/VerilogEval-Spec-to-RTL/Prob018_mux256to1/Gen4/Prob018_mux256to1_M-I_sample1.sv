module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // Direct indexing for mux output
    assign out = in[sel];

endmodule