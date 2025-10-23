module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // Directly assign the selected bit from the input vector
    assign out = in[sel];

endmodule