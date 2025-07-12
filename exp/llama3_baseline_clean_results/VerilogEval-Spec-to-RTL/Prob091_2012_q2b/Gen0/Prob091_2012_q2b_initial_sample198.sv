module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Logic for Y1: Transition to state B from A when w is '1'
assign Y1 = y[0] & w;

// Logic for Y3: Considering the one-hot encoding and transitions to state D
assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[3] & (w | ~w)) | (y[4] & ~w) | (y[5] & ~w);

endmodule