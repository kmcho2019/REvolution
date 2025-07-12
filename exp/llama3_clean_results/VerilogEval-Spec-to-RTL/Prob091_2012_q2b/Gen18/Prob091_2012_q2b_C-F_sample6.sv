module StateBNext(
    input  [5:0] y,
    input  w,
    output Y1
);

    // Directly assign next state for Y1 (State B) based on current state and input w
    // This logic is minimal and necessary for the state machine transition.
    assign Y1 = w & y[0];

endmodule

module StateDNext(
    input  [5:0] y,
    input  w,
    output Y3
);

    // Assign next state for Y3 (State D) considering all possible transitions to State D
    // This expression is necessary but can be optimized for the synthesis tool to recognize opportunities for reduction.
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule

module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    StateBNext stateB(.y(y), .w(w), .Y1(Y1));
    StateDNext stateD(.y(y), .w(w), .Y3(Y3));

endmodule