module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Simplified logic equations for Y2 and Y4
assign Y1 = (y[0] & w) | (y[3] & ~w) | (y[4] & ~w); // Corrected for Y2 (y[1])
assign Y3 = (y[1] & w) | (y[2] & ~w); // Corrected for Y4 (y[3])

endmodule