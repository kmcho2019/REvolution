module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is simply when in state A and w=1
    assign Y1 = y[0] & w;

    // Y3 is active when not in state A and w=0
    // This covers all transitions to D (from B,C,E,F with w=0)
    assign Y3 = ~y[0] & ~w;

endmodule