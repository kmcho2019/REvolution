module TopModule (
    input [5:0] y,
    input w,
    output Y2,  // Next state y[1] (B)
    output Y4   // Next state y[3] (D)
);

    assign Y2 = y[0] & ~w;
    assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule