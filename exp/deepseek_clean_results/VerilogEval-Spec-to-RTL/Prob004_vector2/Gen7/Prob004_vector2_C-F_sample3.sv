module TopModule (
    input  [31:0] in,    // Input:  [Byte3][Byte2][Byte1][Byte0] (MSB to LSB)
    output [31:0] out    // Output: [Byte0][Byte1][Byte2][Byte3] (reversed byte order)
);
    // Reverse byte order using optimal concatenation
    // This implementation has zero timing impact and minimal area/power
    assign out = {in[7:0],   // Original Byte0 becomes new Byte3
                  in[15:8],  // Original Byte1 becomes new Byte2
                  in[23:16], // Original Byte2 becomes new Byte1
                  in[31:24]  // Original Byte3 becomes new Byte0
                 };
endmodule