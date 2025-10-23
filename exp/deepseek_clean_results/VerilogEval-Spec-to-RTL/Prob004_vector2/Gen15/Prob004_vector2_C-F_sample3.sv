module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Optimal direct concatenation for 32-bit byte reversal
    // Organized for maximum readability and future parameterization
    assign out = {in[ 7: 0],  // Byte 0 -> Byte 3
                 in[15: 8],   // Byte 1 -> Byte 2
                 in[23:16],   // Byte 2 -> Byte 1
                 in[31:24]};  // Byte 3 -> Byte 0
endmodule