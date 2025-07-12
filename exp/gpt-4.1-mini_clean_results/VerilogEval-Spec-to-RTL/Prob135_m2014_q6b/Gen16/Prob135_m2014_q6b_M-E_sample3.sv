module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Decode states
    wire state_B = (~y2 & ~y1 &  y0); // 001
    wire state_C = (~y2 &  y1 & ~y0); // 010
    wire state_E = ( y2 & ~y1 & ~y0); // 100
    wire state_F = ( y2 & ~y1 &  y0); // 101

    // Next state for y[1]
    wire y1_next = state_B | state_F | (w & (state_C | state_E));

    // Output Y1 is next state of y[1]
    assign Y1 = y1_next;

endmodule