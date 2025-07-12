module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding: A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

// Derive next-state logic for Y1, Y2, Y3, and Y4
assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0]) | (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0]); // Next state is A or F when w is 1 or 0 respectively
assign Y2 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0]) & w | (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0]) & ~w; // Next state is A or B when w is 1 or C is 0
assign Y3 = (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0]) | (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0]) & w; // Next state is D or E when w is 1

// Since the actual question was about Y1 and Y3
// Y2 and Y4 have been used just to demonstrate how one can derive next state logic

endmodule