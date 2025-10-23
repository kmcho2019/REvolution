module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Implement next-state signals Y2 and Y4 based on one-hot encoding
assign Y1 = (y[0] & w); // Next state is B if current state is A and w is 1
assign Y3 = (y[0] & ~w) | (y[1] & w) | (y[2] & w) | (y[4] & ~w); // Next state is D under specified conditions

endmodule