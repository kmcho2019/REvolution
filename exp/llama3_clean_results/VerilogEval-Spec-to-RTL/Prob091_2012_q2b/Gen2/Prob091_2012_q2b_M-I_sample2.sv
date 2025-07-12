module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 is 1 when the FSM is in A and w is 1 (to transition to B), or when it is already in B and w is 1 (to stay in a state that could lead to B in the next cycle considering the FSM's rules)
assign Y1 = (w & y[0]) | (w & y[1]);

// Y3 is 1 when the FSM is in B and w is 0, or in C and w is 0, or in E and w is 0, or in D and w is 0 (since D's next state when w=1 is not D but the logic for y[3] input should consider all possible transitions to D)
assign Y3 = (~w & (y[1] | y[2] | y[4] | y[3]));

endmodule