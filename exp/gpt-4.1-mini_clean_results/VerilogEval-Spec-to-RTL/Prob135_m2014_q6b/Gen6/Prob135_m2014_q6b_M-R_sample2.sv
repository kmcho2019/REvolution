module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // next_y1 = B | (C & w) | (E & w) | F
    // Where:
    // B = ~y2 & ~y1 & y0
    // C = ~y2 & y1 & ~y0
    // E = y2 & ~y1 & ~y0
    // F = y2 & ~y1 & y0

    assign Y1 = (~y[2] & ~y[1] & y[0])             // B
                | ((~y[2] & y[1] & ~y[0]) & w)    // C & w
                | ((y[2] & ~y[1] & ~y[0]) & w)    // E & w
                | (y[2] & ~y[1] & y[0]);          // F

endmodule