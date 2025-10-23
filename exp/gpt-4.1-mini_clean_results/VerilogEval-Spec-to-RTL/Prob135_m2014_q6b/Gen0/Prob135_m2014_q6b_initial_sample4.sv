module TopModule (
    input  [2:0] y,  // current state
    input        w,
    output       Y1
);
    wire y2, y1, y0;
    assign y2 = y[2];
    assign y1 = y[1];
    assign y0 = y[0];

    wire y1_next;

    assign y1_next = 
        (~y2 & ~y1 & y0) |
        (~y2 & y1 & ~y0 & w) |
        (y2 & ~y1 & ~y0 & w) |
        (y2 & ~y1 & y0);

    assign Y1 = y1;

endmodule