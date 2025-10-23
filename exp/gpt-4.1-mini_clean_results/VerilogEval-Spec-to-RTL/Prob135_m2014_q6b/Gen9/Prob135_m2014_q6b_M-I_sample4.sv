module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // States encoded in y: A=000, B=001, C=010, D=011, E=100, F=101
    // next_y1 = B | (C & w) | (E & w) | F
    // = (~y2 & ~y1 & y0) | ((~y2 & y1 & ~y0) & w) | ((y2 & ~y1 & ~y0) & w) | (y2 & ~y1 & y0)
    // Factor w terms with ~y2: ((~y2 & w) & (y1 & ~y0)) + (~y2 & ~y1 & y0) + (y2 & ~y1 & y0) + (y2 & ~y1 & ~y0 & w)

    wire not_y2 = ~y[2];
    wire not_y1 = ~y[1];
    wire not_y0 = ~y[0];

    wire term1 = not_y2 & not_y1 & y[0];          // B
    wire term2 = (not_y2 & w) & (y[1] & not_y0); // C & w
    wire term3 = y[2] & not_y1 & y[0];            // F
    wire term4 = (y[2] & not_y1 & not_y0) & w;    // E & w (rearranged F & w to E & w as F not matching E)

    assign Y1 = term1 | term2 | term3 | term4;

endmodule