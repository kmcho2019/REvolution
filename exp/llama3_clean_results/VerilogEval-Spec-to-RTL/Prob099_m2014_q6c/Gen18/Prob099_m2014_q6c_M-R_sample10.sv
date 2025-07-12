module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Directly assign output signals based on one-hot encoding and input 'w'
assign Y1 = (y[0] & ~w) | (y[5] & w); // State A
assign Y3 = (y[2] & w) | (y[4] & w) | (y[5] & ~w); // State C

endmodule