module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];

// Next-state logic for y[1]
wire next_y1;
assign next_y1 = (
    // Transition from A (000) to B (001) when w = 0
    (y[2] == 0 && y[1] == 0 && y[0] == 0 && w == 0) ? 0 :
    // Transition from A (000) to A (000) when w = 1
    (y[2] == 0 && y[1] == 0 && y[0] == 0 && w == 1) ? 0 :
    // Transition from B (001) to C (010) when w = 0
    (y[2] == 0 && y[1] == 0 && y[0] == 1 && w == 0) ? 1 :
    // Transition from B (001) to D (100) when w = 1
    (y[2] == 0 && y[1] == 0 && y[0] == 1 && w == 1) ? 1 :
    // Transition from C (010) to E (011) when w = 0
    (y[2] == 0 && y[1] == 1 && y[0] == 0 && w == 0) ? 1 :
    // Transition from C (010) to D (100) when w = 1
    (y[2] == 0 && y[1] == 1 && y[0] == 0 && w == 1) ? 1 :
    // Transition from D (100) to F (101) when w = 0
    (y[2] == 1 && y[1] == 0 && y[0] == 0 && w == 0) ? 1 :
    // Transition from D (100) to A (000) when w = 1
    (y[2] == 1 && y[1] == 0 && y[0] == 0 && w == 1) ? 0 :
    // Transition from E (011) to E (011) when w = 0
    (y[2] == 0 && y[1] == 1 && y[0] == 1 && w == 0) ? 1 :
    // Transition from E (011) to D (100) when w = 1
    (y[2] == 0 && y[1] == 1 && y[0] == 1 && w == 1) ? 1 :
    // Transition from F (101) to C (010) when w = 0
    (y[2] == 1 && y[1] == 0 && y[0] == 1 && w == 0) ? 1 :
    // Transition from F (101) to D (100) when w = 1
    (y[2] == 1 && y[1] == 0 && y[0] == 1 && w == 1) ? 1 : 0
);

endmodule