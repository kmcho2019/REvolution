module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    // Y1: transition from A to B (w=0)
    assign Y1 = ~w & y[0];

    // Y2: transition from B to C (w=0)
    assign Y2 = ~w & y[1];

    // Y3: transitions to D (from B,C,E,F with w=1)
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

    // Y4: transitions to/staying in E (from C with w=0 or E with w=0)
    assign Y4 = ~w & (y[2] | y[4]);

endmodule