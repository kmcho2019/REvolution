module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

assign Y1 = y[0] && w; // Next state is B when current state is A and w is 1
assign Y3 = (y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[3] && !w); // Next state is D when current state is B and w is 0, or C and w is 0, or E and w is 0, or D and w is 0

endmodule