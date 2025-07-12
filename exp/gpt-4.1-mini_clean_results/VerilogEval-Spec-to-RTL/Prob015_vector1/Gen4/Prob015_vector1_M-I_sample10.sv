module TopModule (
    input  [15:0] in,      // 16-bit input word
    output wire [7:0] out_hi,  // upper byte of input [15:8]
    output wire [7:0] out_lo   // lower byte of input [7:0]
);

    // Combinational assignments splitting 16-bit input into two 8-bit outputs
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];

endmodule