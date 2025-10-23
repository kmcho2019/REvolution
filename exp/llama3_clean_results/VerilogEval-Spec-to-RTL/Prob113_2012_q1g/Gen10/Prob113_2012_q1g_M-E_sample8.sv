module TopModule(
    input  [3:0] x,
    output       f
);

    wire [15:0] lut;

    assign lut[0]  = 1'b1; // x = 0000
    assign lut[1]  = 1'b0; // x = 0001
    assign lut[2]  = 1'b0; // x = 0010
    assign lut[3]  = 1'b1; // x = 0011
    assign lut[4]  = 1'b0; // x = 0100
    assign lut[5]  = 1'b0; // x = 0101
    assign lut[6]  = 1'b0; // x = 0110
    assign lut[7]  = 1'b0; // x = 0111
    assign lut[8]  = 1'b1; // x = 1000
    assign lut[9]  = 1'b1; // x = 1001
    assign lut[10] = 1'b1; // x = 1010
    assign lut[11] = 1'b0; // x = 1011
    assign lut[12] = 1'b1; // x = 1100
    assign lut[13] = 1'b1; // x = 1101
    assign lut[14] = 1'b1; // x = 1110
    assign lut[15] = 1'b0; // x = 1111

    assign f = lut[x];

endmodule