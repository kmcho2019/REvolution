module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Directly assign output signals based on one-hot encoding and input 'w'
// Y1 corresponds to state B (y[1])
assign Y1 = (y[0] & ~w) | (y[5] & w) | (y[3] & ~w) | (y[4] & w);

// Y3 corresponds to state D (y[3])
assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & ~w);

endmodule