module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Derive next-state signals Y1 and Y3 based on one-hot encoding
assign Y1 = (y[0] && ~w) || (y[3] && ~w); // Transition to A or already in A with w=0
assign Y3 = (y[1] && ~w); // Transition to C from B with w=0

endmodule