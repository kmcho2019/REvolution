module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Derive next-state signals Y2 and Y4
wire Y2, Y4;

assign Y2 = (y[1] & w) | (y[4] & w) | (y[3] & ~w);
assign Y4 = (y[3] & ~w) | (y[5] & w);

// Output signals Y1 and Y3 are simply y[0] and y[2]
assign Y1 = y[0];
assign Y3 = y[2];

endmodule