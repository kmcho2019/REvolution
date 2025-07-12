module TopModule(
    input [5:0] y, // current state
    input w,
    output Y1, // next state y[0]
    output Y3  // next state y[2]
);

assign Y1 = (y[3] && !w); // next state is A when current state is D and w is 0
assign Y3 = (y[1] && !w); // next state is C when current state is B and w is 0

endmodule