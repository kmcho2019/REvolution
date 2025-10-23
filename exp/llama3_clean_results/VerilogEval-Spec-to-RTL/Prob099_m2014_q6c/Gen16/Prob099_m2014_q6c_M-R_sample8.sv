module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Directly assign next-state signals based on one-hot encoding and input 'w'
assign Y1 = (y[0] & ~w) | (y[1] & w); // Next state for 'B'
assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[3] & 1'b1) | (y[4] & ~w) | (y[5] & ~w); // Next state for 'D'

endmodule