module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Reverse byte order by direct assignment:
    // Byte 0 (LSB) -> Byte 3 (MSB)
    // Byte 1       -> Byte 2
    // Byte 2       -> Byte 1
    // Byte 3 (MSB) -> Byte 0 (LSB)
    assign out[31:24] = in[7:0];   // MSB <- LSB
    assign out[23:16] = in[15:8];  // 
    assign out[15:8]  = in[23:16]; // 
    assign out[7:0]   = in[31:24]; // LSB <- MSB
endmodule