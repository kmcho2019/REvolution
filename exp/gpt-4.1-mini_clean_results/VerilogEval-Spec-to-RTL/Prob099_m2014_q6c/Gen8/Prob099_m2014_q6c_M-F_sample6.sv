module good1 (
    input  [5:0] y,   // One-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1,  // Next-state bit corresponding to B (y[1])
    output       Y3   // Next-state bit corresponding to D (y[3])
);

// From the FSM:
// Y1 (next B) is active when current state is A and input=0 => y[0] & ~w
// Y3 (next D) is active when w=1 and current state is B, C, D, E or F => w & (y[1]|y[2]|y[3]|y[4]|y[5])

assign Y1 = y[0] & ~w;
assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule