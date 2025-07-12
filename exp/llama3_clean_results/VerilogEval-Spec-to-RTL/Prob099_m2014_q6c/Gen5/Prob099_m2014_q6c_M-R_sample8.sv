module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

// Directly assign the values of Y1, Y2, Y3, and Y4 based on the current state (y) and the input (w)
assign Y1 = (y[0] && !w) || (y[3] && !w) || (y[5] && !w); // Next state is A
assign Y2 = (y[0] && !w) || (y[3] && !w) || (y[5] && !w); // Next state is B
assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w); // Next state is D
assign Y4 = (y[2] && !w); // Next state is E

endmodule