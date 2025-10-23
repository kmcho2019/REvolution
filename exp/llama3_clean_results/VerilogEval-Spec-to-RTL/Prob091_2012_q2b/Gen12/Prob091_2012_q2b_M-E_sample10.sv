module CentralizedController(
    input  [5:0] y,
    input  w,
    output [5:0] nextState
);

    // Implement the next-state logic for each flip-flop
    // based on the current state and input w
    assign nextState[0] = ~w & (y[5] | y[3]); // Next state for y[0]
    assign nextState[1] = w & y[0]; // Next state for y[1]
    assign nextState[2] = ~w & y[1]; // Next state for y[2]
    assign nextState[3] = ~w & (y[1] | y[2] | y[4] | y[5]); // Next state for y[3]
    assign nextState[4] = w & y[2]; // Next state for y[4]
    assign nextState[5] = w & y[4]; // Next state for y[5]

endmodule

module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    wire [5:0] nextState;

    CentralizedController controller(.y(y), .w(w), .nextState(nextState));

    // Assign the next-state values for Y1 and Y3
    assign Y1 = nextState[1];
    assign Y3 = nextState[3];

endmodule