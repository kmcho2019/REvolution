module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Reverse byte order of 32-bit input
    // Original: [byte3, byte2, byte1, byte0]
    // Output:   [byte0, byte1, byte2, byte3]
    assign out = {in[7:0],   // byte0
                  in[15:8],  // byte1
                  in[23:16], // byte2
                  in[31:24]  // byte3
                 };
endmodule