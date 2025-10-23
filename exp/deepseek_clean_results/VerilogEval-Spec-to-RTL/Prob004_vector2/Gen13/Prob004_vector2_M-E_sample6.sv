module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Byte 0 (LSB) comes from byte 3 (MSB) of input
    assign out[7:0]   = in[31:24];
    
    // Byte 1 comes from byte 2 of input
    assign out[15:8]  = in[23:16];
    
    // Byte 2 comes from byte 1 of input
    assign out[23:16] = in[15:8];
    
    // Byte 3 (MSB) comes from byte 0 (LSB) of input
    assign out[31:24] = in[7:0];
endmodule