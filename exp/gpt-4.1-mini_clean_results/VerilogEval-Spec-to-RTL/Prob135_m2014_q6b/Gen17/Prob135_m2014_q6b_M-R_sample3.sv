module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    wire term1 = ~y1 & y0;
    wire term2 = w & (y1 | y2) & ~y0;

    wire y1_next = term1 | term2;

    assign Y1 = y1_next;

endmodule