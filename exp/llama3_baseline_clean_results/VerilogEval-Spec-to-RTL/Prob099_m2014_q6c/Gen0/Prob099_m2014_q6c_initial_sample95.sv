module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y2 corresponds to signal y[1]
assign Y2 = (~w & y[0]); // Next state is B when current state is A and w is 0

// Y4 corresponds to signal y[3]
assign Y4 = (w & (y[1] | y[2] | y[4] | y[5] | y[3])); // Next state is D when current state is B, C, E, F, or D and w is 1

// Since Y1 and Y3 are not derived in the problem, we will just assign them to 0
assign Y1 = 1'b0;
assign Y3 = 1'b0;

endmodule