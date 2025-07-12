module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

assign Y1 = (y[0] && w) || (y[2] && w); // Next state is B if current state is A and w=1, or current state is C and w=1
assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w) || (y[3] && w); // Next state is D if current state is B and w=1, or current state is C and w=1, or current state is E and w=1, or current state is F and w=1, or current state is D and w=1

endmodule