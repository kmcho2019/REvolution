module StateBNext(
    input  [5:0] y,
    input  w,
    output Y1
);

    // State B (y[1]) can be reached from state A (y[0]) when w is 1
    assign Y1 = w & y[0];

endmodule

module StateDNext(
    input  [5:0] y,
    input  w,
    output Y3
);

    // State D (y[3]) can be reached from states B, C, E, and F when w is 0
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule

module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    StateBNext stateB(.y(y),.w(w),.Y1(Y1));
    StateDNext stateD(.y(y),.w(w),.Y3(Y3));

endmodule