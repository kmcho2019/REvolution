module TopModule (
    input  [2:0] y,  // current state encoding: A=000, B=001, C=010, D=011, E=100, F=101
    input        w,
    output       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next-state logic for y[1] based on current state (y) and input w
    // Derived from FSM transitions:
    // y1_next = (~y2 & ~y1 & y0) | (~y2 & y1 & ~y0 & w) | (y2 & ~y1 & ~y0 & w) | (y2 & ~y1 & y0);
    wire y1_next = 
        (~y2 & ~y1 & y0) |
        (~y2 & y1 & ~y0 & w) |
        (y2 & ~y1 & ~y0 & w) |
        (y2 & ~y1 & y0);

    // Output current y[1] as Y1
    assign Y1 = y1;

endmodule