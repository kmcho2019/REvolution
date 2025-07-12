module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Original next_y1 logic from FSM transitions:
    // next_y1 = (~y2 & ~y1 & y0)          // B
    //         | (~y2 & y1 & ~y0 & w)     // C & w
    //         | (y2 & ~y1 & (~y0 & w))   // E & w
    //         | (y2 & ~y1 & y0);         // F

    // Factor (y2 & ~y1) common term:
    // next_y1 = (~y2 & ~y1 & y0)
    //         | (~y2 & y1 & ~y0 & w)
    //         | (y2 & ~y1 & (y0 | (~y0 & w)))
    // Simplify inside parentheses:
    // y0 | (~y0 & w) = y0 + w - y0*w = y0 + w (since if y0=1 or w=1, term=1)
    // So, y0 | (~y0 & w) = y0 | w

    // So final logic:
    // next_y1 = (~y2 & ~y1 & y0)
    //         | (~y2 & y1 & ~y0 & w)
    //         | (y2 & ~y1 & (y0 | w))

    assign Y1 = (~y[2] & ~y[1] & y[0])                      // B
              | (~y[2] & y[1] & ~y[0] & w)                 // C & w
              | (y[2] & ~y[1] & (y[0] | w));               // E & w or F

endmodule