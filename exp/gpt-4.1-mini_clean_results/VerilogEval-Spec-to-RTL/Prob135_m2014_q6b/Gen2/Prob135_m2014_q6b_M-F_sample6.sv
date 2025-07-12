module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

    // current state bits
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // next state bit y[1] logic:
    // next_y1 = B + (C & w) + (E & w) + F
    // B=001: ~y2 & ~y1 & y0
    // C=010: ~y2 & y1 & ~y0
    // E=100: y2 & ~y1 & ~y0
    // F=101: y2 & ~y1 & y0

    wire next_y1 = 
        (~y2 & ~y1 & y0)             // B
      | ((~y2 & y1 & ~y0) & w)      // C & w
      | ((y2 & ~y1 & ~y0) & w)      // E & w
      | (y2 & ~y1 & y0);            // F

    // output current state's y[1]
    assign Y1 = y1;

endmodule