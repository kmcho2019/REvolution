module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: transition from A to B (w=0)
    assign Y1 = ~w & y[0];

    // Y3: transitions to D (from B,C,E,F with w=1)
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule