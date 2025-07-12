module TopModule (
    input  [31:0] in,    // Input word (4 bytes: [byte3, byte2, byte1, byte0])
    output [31:0] out    // Output word (bytes reversed: [byte0, byte1, byte2, byte3])
);
    // Reverse byte order by concatenating bytes in reverse sequence
    assign out = {in[7:0],   // byte0
                  in[15:8],  // byte1
                  in[23:16], // byte2
                  in[31:24]}; // byte3
endmodule