module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// A is 000001, B is 000010, C is 000100, D is 001000, E is 010000, F is 100000
assign Y1 = (y[0] && w); // Next state will be B when current state is A and w is 1
assign Y3 = ((y[1] && w) || (y[5] && w)); // Next state will be C when current state is B and w is 1, or when current state is F and w is 1

endmodule