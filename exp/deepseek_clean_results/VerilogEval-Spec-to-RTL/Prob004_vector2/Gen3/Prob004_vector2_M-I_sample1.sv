module TopModule (
    input  [31:0] in,    // Input:  [Byte3][Byte2][Byte1][Byte0]
    output [31:0] out    // Output: [Byte0][Byte1][Byte2][Byte3]
);
    localparam BYTE_WIDTH = 8;  // Each byte is 8 bits
    
    // Reverse byte order by concatenating in reverse sequence
    assign out = {in[0*BYTE_WIDTH +: BYTE_WIDTH],   // Byte0 (LSB)
                  in[1*BYTE_WIDTH +: BYTE_WIDTH],   // Byte1
                  in[2*BYTE_WIDTH +: BYTE_WIDTH],   // Byte2
                  in[3*BYTE_WIDTH +: BYTE_WIDTH]    // Byte3 (MSB)
                 };
endmodule