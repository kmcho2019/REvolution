module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state logic for Y1 (y[1]) - state B
    // Set only when transitioning from A (y[0]) with w=0
    assign Y1 = y[0] & ~w;

    // Next state logic for Y3 (y[3]) - state D
    // Set when transitioning from B/C/E/F (y[1/2/4/5]) with w=1
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule