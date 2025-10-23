module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Next state logic for Y1 (y[1])
// State B (y[1] = 1) can be reached from state A (y[0] = 1) with w = 0
assign Y1 = (y[0] && !w);

// Next state logic for Y3 (y[3])
// State D (y[3] = 1) can be reached from:
// - State B (y[1] = 1) with w = 1
// - State C (y[2] = 1) with w = 1
// - State E (y[4] = 1) with w = 1
// - State D (y[3] = 1) itself with w = 1
assign Y3 = ((y[1] || y[2] || y[4] || y[3]) && w);

endmodule