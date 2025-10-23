module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Directly encode the logic for Y1 and Y3 based on the state machine transitions
assign Y1 = (y[0] && !w) || (y[3] && w); // Next state is A (state B's next state is correctly determined)
assign Y3 = (y[2] && !w) || (y[5] && w) || (y[1] && !w); // Next state is C (correctly determining state C's next state based on the transitions)

endmodule