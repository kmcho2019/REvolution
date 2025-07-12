module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // next_y1 = B | (C & w) | (E & w) | F
    // B = ~y2 & ~y1 & y0
    // C = ~y2 & y1 & ~y0
    // E = y2 & ~y1 & ~y0
    // F = y2 & ~y1 & y0
    // Factor out (~y1):
    // next_y1 = (~y1 & ( (~y2 & y0) | (y2 & ~y0) | (y2 & y0) & w )) | ( (~y2 & y1 & ~y0) & w )

    wire not_y2 = ~y[2];
    wire not_y1 = ~y[1];
    wire not_y0 = ~y[0];

    assign Y1 = (not_y1 & ((not_y2 & y[0]) | (y[2] & (not_y0 | y[0]) & w))) | ((not_y2 & y[1] & not_y0) & w);

endmodule