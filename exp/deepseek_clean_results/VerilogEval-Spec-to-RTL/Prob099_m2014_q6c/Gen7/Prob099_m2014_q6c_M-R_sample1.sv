module TopModule (
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

    assign Y2 = y[0] & ~w;  // A->B when w=0
    assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);  // D next state when w=1 in B,C,E,F

endmodule