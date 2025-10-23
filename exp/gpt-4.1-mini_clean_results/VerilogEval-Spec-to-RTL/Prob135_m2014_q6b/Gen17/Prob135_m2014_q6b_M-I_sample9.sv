module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // next_y1 = (~y1 & y0) | (w & (y1 | y2) & ~y0)
    assign Y1 = (~y[1] & y[0]) | (w & (y[1] | y[2]) & ~y[0]);

endmodule