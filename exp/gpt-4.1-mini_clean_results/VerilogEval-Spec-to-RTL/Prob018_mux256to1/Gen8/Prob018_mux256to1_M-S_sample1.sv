module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Directly select the bit from the input vector indexed by sel
    assign out = in[sel];
endmodule