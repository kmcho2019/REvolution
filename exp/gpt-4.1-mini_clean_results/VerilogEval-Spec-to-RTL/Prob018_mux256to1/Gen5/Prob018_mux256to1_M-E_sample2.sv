module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // Directly assign out to the bit selected from in by sel
    assign out = in[sel];

endmodule