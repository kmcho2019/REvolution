module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Next-state signals Y2 and Y4
assign Y2 = (y[0] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w); // y[1] next-state signal
assign Y4 = (y[1] & w) | (y[2] & w) | (y[4] & ~w) | (y[5] & w); // y[3] next-state signal

// Output signals Y1 and Y3
assign Y1 = y[0]; // Output signal corresponding to state A
assign Y3 = y[2]; // Output signal corresponding to state C

endmodule