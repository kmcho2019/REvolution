module TopModule (
    input [5:0] y, // current state
    input w, // input to the finite-state machine
    output Y1, // input of state flip-flop y[1]
    output Y3 // input of state flip-flop y[3]
);

// Using the one-hot encoding to determine the next state
assign Y1 = (y[0] && !w) || (y[1] && !w) || (y[3] && w) || (y[4] && !w); // y[1] is set for states A, B, D, and E
assign Y3 = (y[2] && !w) || (y[4] && w); // y[3] is set for states C and E when w=1

endmodule