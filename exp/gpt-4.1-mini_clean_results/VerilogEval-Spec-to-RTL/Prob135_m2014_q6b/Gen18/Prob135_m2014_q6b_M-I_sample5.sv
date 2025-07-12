module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    wire y1_or_y2 = y1 | y2;

    // y[1]_next = (~y1 & y0) | (w & y1_or_y2 & ~y0)
    assign Y1 = (y0 & ~y1) | (~y0 & w & y1_or_y2);

endmodule