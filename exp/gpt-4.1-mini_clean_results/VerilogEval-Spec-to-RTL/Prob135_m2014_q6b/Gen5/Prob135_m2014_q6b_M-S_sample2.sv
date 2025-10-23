module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // next y[1] = B | (C & w) | (E & w) | F
    // where B = 000001, C= 010, E=100, F=101 as y[2:0]
    assign Y1 = (~y[2] & ~y[1] & y[0]) | ((~y[2] & y[1] & ~y[0] & w)) | (y[2] & ~y[1] & ~y[0] & w) | (y[2] & ~y[1] & y[0]);

endmodule