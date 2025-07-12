module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Reverse byte order using explicit range naming for clarity
    // Original: [byte3][byte2][byte1][byte0]
    // Reversed: [byte0][byte1][byte2][byte3]
    assign out = {in[7:0],   in[15:8],  // byte0 and byte1
                  in[23:16], in[31:24]}; // byte2 and byte3
endmodule