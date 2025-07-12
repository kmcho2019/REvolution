module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

// Directly encode the logic for Y1, Y2, Y3, and Y4 based on the state machine transitions
assign Y1 = (y[0] && !w) || (y[3] && w); // Next state is B (state A's next state is correctly determined)
assign Y2 = (y[1] && !w) || (y[0] && w) || (y[5] && !w); // Next state is C or D (correctly determining state B's next states)
assign Y3 = (y[2] && !w) || (y[1] && w) || (y[4] && w); // Next state is E or D (correctly determining state C's next states)
assign Y4 = (y[4] && !w) || (y[3] && w) || (y[2] && w); // Next state is F or D (correctly determining state D's next states)

endmodule