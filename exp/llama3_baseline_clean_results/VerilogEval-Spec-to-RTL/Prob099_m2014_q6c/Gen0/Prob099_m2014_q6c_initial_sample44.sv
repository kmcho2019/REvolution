module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = y[3] & w; // Next state is A when current state is D and w is 1
assign Y3 = (y[1] & ~w) | (y[5] & ~w); // Next state is C when current state is B and w is 0, or when current state is F and w is 0

endmodule