module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // Directly assign output to the selected bit of input vector
    assign out = in[sel];

endmodule