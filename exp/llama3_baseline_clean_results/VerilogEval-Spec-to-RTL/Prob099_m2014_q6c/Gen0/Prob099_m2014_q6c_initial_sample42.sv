module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// One-hot encoding: A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

// Next-state logic for Y2 (state B)
assign Y2 = (y[0] && w) || (y[3] && ~w); // Go to B when in A and w=1, or in D and w=0

// Next-state logic for Y4 (state D)
assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && ~w); // Go to D when in B and w=1, in C and w=1, or in E and w=0

// Output logic for Y1 (state A)
assign Y1 = y[0]; // Simply output the current state of A

endmodule