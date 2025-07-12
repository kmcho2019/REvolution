module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is simply the A->B transition
    assign Y1 = y[0] & w;

    // Y3 combines all transitions to D (from B, C, or F when w=0)
    assign Y3 = ~w & (y[1] | y[2] | y[5]);

endmodule