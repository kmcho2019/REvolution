module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = (y[0] & w) | y[1];  // Next state logic for y[1]
assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | y[3];  // Next state logic for y[3]

endmodule