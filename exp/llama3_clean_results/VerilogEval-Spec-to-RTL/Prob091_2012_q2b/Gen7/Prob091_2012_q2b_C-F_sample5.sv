module StateBNext(
    input  [5:0] y,
    input  w,
    output Y1
);

    // Directly compute the value of Y1 using an assign statement
    assign Y1 = w & y[0]; // State B can be reached from state A when w is 1

endmodule

module StateDNext(
    input  [5:0] y,
    input  w,
    output Y3
);

    // Directly compute the value of Y3 using an assign statement
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]); // State D can be reached from states B, C, E, F when w is 0

endmodule

module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Instantiate the separate modules for Y1 and Y3
    StateBNext stateB(.y(y),.w(w),.Y1(Y1));
    StateDNext stateD(.y(y),.w(w),.Y3(Y3));

endmodule