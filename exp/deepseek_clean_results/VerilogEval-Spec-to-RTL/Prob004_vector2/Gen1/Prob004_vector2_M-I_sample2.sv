module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Byte positions (each byte is 8 bits)
    localparam BYTE0 = 7:0;
    localparam BYTE1 = 15:8;
    localparam BYTE2 = 23:16;
    localparam BYTE3 = 31:24;
    
    // Reverse byte order: [byte3,byte2,byte1,byte0] -> [byte0,byte1,byte2,byte3]
    assign out = {in[BYTE0], in[BYTE1], in[BYTE2], in[BYTE3]};
endmodule