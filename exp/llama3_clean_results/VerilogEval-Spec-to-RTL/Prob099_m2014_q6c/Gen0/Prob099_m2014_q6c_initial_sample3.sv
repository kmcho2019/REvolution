module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding for states A, B, C, D, E, F
// A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

// Y1 corresponds to state A
assign Y1 = (y[3] & w); // D and w=1

// Y3 corresponds to state C
assign Y3 = ((y[1] | y[5]) & ~w); // (B or F) and w=0

endmodule