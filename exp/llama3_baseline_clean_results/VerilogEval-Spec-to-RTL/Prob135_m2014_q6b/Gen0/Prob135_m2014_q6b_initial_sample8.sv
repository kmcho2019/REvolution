module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    // Since the exact implementation of the FSM was not required, we only focus on the next-state logic for y[1]

endmodule