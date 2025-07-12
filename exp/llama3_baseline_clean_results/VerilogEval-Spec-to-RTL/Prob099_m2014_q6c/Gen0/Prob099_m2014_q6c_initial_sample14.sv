module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Deriving next-state signals Y1 and Y3 by inspection
assign Y1 = (~w) & (y[3] | y[5]);  // Next state is A when current state is D or F and w is 0
assign Y3 = (~w) & (y[1] | y[5]);  // Next state is C when current state is B or F and w is 0

endmodule