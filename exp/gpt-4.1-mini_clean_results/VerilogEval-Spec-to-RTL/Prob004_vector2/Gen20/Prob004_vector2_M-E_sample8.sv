module TopModule (
    input  [31:0] in,
    output [31:0] out
);

localparam BYTE_SIZE = 8;

assign out = {
    in[BYTE_SIZE-1 : 0],           // byte 0 (least significant byte)
    in[2*BYTE_SIZE-1 : BYTE_SIZE], // byte 1
    in[3*BYTE_SIZE-1 : 2*BYTE_SIZE], // byte 2
    in[4*BYTE_SIZE-1 : 3*BYTE_SIZE]  // byte 3 (most significant byte)
};

endmodule