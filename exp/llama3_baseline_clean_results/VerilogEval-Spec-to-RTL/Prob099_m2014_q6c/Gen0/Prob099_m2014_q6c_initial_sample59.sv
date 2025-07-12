module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoded state assignments
// A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

// Next-state signal Y1 (y[0]) is '1' if current state is A and w is '0', or if current state is D and w is '1'
assign Y1 = (~w & y[0]) | (w & y[3]);

// Next-state signal Y3 (y[2]) is '1' if current state is B and w is '0', or if current state is C and w is '1'
assign Y3 = (~w & y[1]) | (w & y[2]);

endmodule