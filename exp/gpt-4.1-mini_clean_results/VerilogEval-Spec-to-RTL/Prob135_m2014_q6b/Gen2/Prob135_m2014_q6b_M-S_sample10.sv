module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    assign Y1 = (~y2) & ((~y1 & y0) | (y1 & ~y0 & w))
                | y2 & (~y1) & ((~y0 & w) | y0);

endmodule