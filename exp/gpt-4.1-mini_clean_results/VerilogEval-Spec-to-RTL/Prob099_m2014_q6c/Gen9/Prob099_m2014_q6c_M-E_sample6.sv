module TopModule (
    input  [5:0] y,   // current state one-hot: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y2,  // next-state signal for state B (y[1])
    output       Y4   // next-state signal for state D (y[3])
);

// Transitions leading to state B (y[1]):
// A (y[0]) --0--> B (y[1])
// So Y2 = y[0] & ~w

// Transitions leading to state D (y[3]):
// B (y[1]) --1--> D (y[3])
// C (y[2]) --1--> D (y[3])
// E (y[4]) --1--> D (y[3])
// F (y[5]) --1--> D (y[3])
// D (y[3]) --1--> A is outgoing, so no self-transition
// So Y4 = w & (y[1] | y[2] | y[4] | y[5])

assign Y2 = y[0] & ~w;
assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule