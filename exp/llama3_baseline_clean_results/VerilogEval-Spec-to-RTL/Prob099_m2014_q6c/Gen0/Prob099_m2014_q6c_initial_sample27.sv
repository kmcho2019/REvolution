module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y2 (next state of y[1])
assign Y2 = (y[0] & w) | (y[1] & ~w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

// Y4 (next state of y[3])
assign Y4 = (y[1] & w) | (y[2] & w) | (y[3] & w) | (y[4] & w) | (y[5] & w);

// Assigning output signals based on the problem statement
assign Y1 = y[0];  // Output Y1 corresponds to state A
assign Y3 = y[2];  // Output Y3 corresponds to state C

endmodule