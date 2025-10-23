module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

// Directly assign next-state signals based on one-hot encoding and input 'w'
assign Y2 = (y[0] & ~w) | (y[1] & w); // Next state for 'B'
assign Y4 = (y[1] & ~w) | (y[2] & ~w) | (y[3] & w) | (y[4] & ~w) | (y[5] & ~w); // Next state for 'D'

assign Y1 = y[0]; // Current state A
assign Y3 = y[2]; // Current state C

endmodule