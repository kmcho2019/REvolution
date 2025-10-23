module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Byte boundaries defined explicitly for clarity
    localparam BYTE0 = 7:0;
    localparam BYTE1 = 15:8;
    localparam BYTE2 = 23:16;
    localparam BYTE3 = 31:24;
    
    assign out = {in[BYTE0], in[BYTE1], in[BYTE2], in[BYTE3]};
endmodule