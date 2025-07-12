module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Derive the optimal logic equations for Y1 and Y3 based on the state machine transitions
assign Y1 = (y[0] && !w) || (y[3] && w) || (y[5] && !w); // Next state is B
assign Y3 = (y[2] && !w) || (y[1] && w) || (y[4] && w); // Next state is E or D

endmodule