module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Decode states
    wire A = (~y2) & (~y1) & (~y0); // 000
    wire B = (~y2) & (~y1) & ( y0); // 001
    wire C = (~y2) & ( y1) & (~y0); // 010
    wire D = (~y2) & ( y1) & ( y0); // 011
    wire E = ( y2) & (~y1) & (~y0); // 100
    wire F = ( y2) & (~y1) & ( y0); // 101

    // Next state logic for y[1] from transition table:
    // y1_next = 1 for B, F always
    // y1_next = w for C, E
    // y1_next = 0 otherwise (A, D)
    wire y1_next = (B | F) | ((C | E) & w);

    assign Y1 = y1;

endmodule