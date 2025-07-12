module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Since we're using one-hot encoding, only one bit of y should be 1 at any time.
// We can simplify the logic based on the given state transitions.

assign Y1 = (y[0] && ~w) || (y[1] && ~w) || (y[2] && ~w) || (y[3] && ~w) || (y[4] && w);
assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[3] && ~w) || (y[4] && ~w) || (y[5] && ~w);

endmodule