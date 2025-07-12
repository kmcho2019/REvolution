module StateMachineController(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

// Next-state signal Y1 (state B)
assign Y1 = (y[0] && ~w);

// Next-state signal Y2 (state C)
assign Y2 = (y[1] && ~w);

// Next-state signal Y3 (state D)
assign Y3 = (y[1] && w) || (y[2] && w) || (y[3] && ~w) || (y[4] && w) || (y[5] && ~w);

// Next-state signal Y4 (state E)
assign Y4 = (y[3] && w) || (y[5] && w);

endmodule

module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    wire Y2, Y4;

    StateMachineController stateMachineController(
       .y(y),
       .w(w),
       .Y1(Y1),
       .Y2(Y2),
       .Y3(Y3),
       .Y4(Y4)
    );

endmodule