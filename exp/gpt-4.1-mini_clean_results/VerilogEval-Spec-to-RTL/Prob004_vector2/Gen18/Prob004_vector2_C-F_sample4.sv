module TopModule (
    input  [31:0] in,
    output [31:0] out
);

genvar i;
generate
    // Reverse byte order: out[7:0]   = in[31:24]
    //                     out[15:8]  = in[23:16]
    //                     out[23:16] = in[15:8]
    //                     out[31:24] = in[7:0]
    for (i = 0; i < 4; i = i + 1) begin : byte_reverse
        assign out[i*8 +: 8] = in[(3 - i)*8 +: 8];
    end
endgenerate

endmodule