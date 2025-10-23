module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // Decode state bits for clarity
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next-state logic for y[1] based on FSM transitions
    assign Y1 = (~y1 & y0) | (w & ((y1 | y2) & ~y0));

endmodule