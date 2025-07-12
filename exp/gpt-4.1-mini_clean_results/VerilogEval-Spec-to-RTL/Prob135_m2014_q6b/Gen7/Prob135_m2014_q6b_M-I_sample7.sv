module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Optimized next-state logic for y[1]:
    // y1_next = (~y1 & y0) | (w & ~y0 & (y2 ^ y1))
    assign Y1 = (~y1 & y0) | (w & ~y0 & (y2 ^ y1));

endmodule