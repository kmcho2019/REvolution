module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Directly assign output by indexing the input vector with sel
    assign out = in[sel];
endmodule