module StateBNext(
    input  [5:0] y,
    input  w,
    output Y1
);

    // State B (y[1]) can be reached from state A (y[0]) when w is 1
    // This logic is already minimal and directly implements the required transition.
    assign Y1 = w & y[0];

endmodule

module StateDNext(
    input  [5:0] y,
    input  w,
    output Y3
);

    // State D (y[3]) can be reached from states B, C, E, and F when w is 0
    // This expression can be optimized by ensuring the synthesis tool recognizes the opportunity to use a single gate for the OR operation if possible.
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