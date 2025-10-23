module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

reg [15:0] lut [0:15];

initial begin
    lut[0] = 1'b0; // a=0, b=0, c=0, d=0
    lut[1] = 1'b0; // a=0, b=0, c=0, d=1
    lut[2] = 1'b0; // a=0, b=0, c=1, d=0
    lut[3] = 1'b0; // a=0, b=0, c=1, d=1
    lut[4] = 1'b0; // a=0, b=1, c=0, d=0
    lut[5] = 1'b1; // a=0, b=1, c=0, d=1
    lut[6] = 1'b1; // a=0, b=1, c=1, d=0
    lut[7] = 1'b1; // a=0, b=1, c=1, d=1
    lut[8] = 1'b0; // a=1, b=0, c=0, d=0
    lut[9] = 1'b1; // a=1, b=0, c=0, d=1
    lut[10] = 1'b1; // a=1, b=0, c=1, d=0
    lut[11] = 1'b1; // a=1, b=0, c=1, d=1
    lut[12] = 1'b0; // a=1, b=1, c=0, d=0
    lut[13] = 1'b1; // a=1, b=1, c=0, d=1
    lut[14] = 1'b1; // a=1, b=1, c=1, d=0
    lut[15] = 1'b1; // a=1, b=1, c=1, d=1
end

always @(*) begin
    case ({a, b, c, d})
        4'b0000: q = lut[0];
        4'b0001: q = lut[1];
        4'b0010: q = lut[2];
        4'b0011: q = lut[3];
        4'b0100: q = lut[4];
        4'b0101: q = lut[5];
        4'b0110: q = lut[6];
        4'b0111: q = lut[7];
        4'b1000: q = lut[8];
        4'b1001: q = lut[9];
        4'b1010: q = lut[10];
        4'b1011: q = lut[11];
        4'b1100: q = lut[12];
        4'b1101: q = lut[13];
        4'b1110: q = lut[14];
        4'b1111: q = lut[15];
    endcase
end

endmodule