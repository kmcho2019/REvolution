module TopModule (
    input  [31:0] in,    // Input:  [Byte3][Byte2][Byte1][Byte0]
    output [31:0] out    // Output: [Byte0][Byte1][Byte2][Byte3]
);
    // Reverse byte order by concatenating in reverse sequence
    assign out = {in[7:0],   // Byte0 (LSB)
                  in[15:8],  // Byte1
                  in[23:16], // Byte2
                  in[31:24]  // Byte3 (MSB)
                 };
endmodule