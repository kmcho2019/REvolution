module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Directly assign the selected bit from input vector using sel as index
    assign out = in[sel];
endmodule