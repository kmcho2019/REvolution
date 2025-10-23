module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 corresponds to state A (y[0])
// It is set to 1 when the current state is D (y[3] = 1) and input w is 1
assign Y1 = y[3] & w;

// Y3 corresponds to state C (y[2])
// It is set to 1 when the current state is B (y[1] = 1) and input w is 0
assign Y3 = y[1] & ~w;

endmodule