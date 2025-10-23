module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // Direct indexing with clean wire declarations
    // Synthesis tool can optimize this into hierarchical structure if beneficial
    assign out = in[sel];

endmodule