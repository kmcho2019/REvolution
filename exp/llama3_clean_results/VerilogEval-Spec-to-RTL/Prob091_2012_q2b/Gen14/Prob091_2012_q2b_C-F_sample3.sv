module CentralizedController(
    input  [5:0] y,
    input  w,
    output reg [5:0] nextState
);

    // Implement the next-state logic for each flip-flop
    // based on the current state and input w
    always @(*) begin
        // State A (y[0]) can transition to B (y[1]) when w is 1
        nextState[0] = ~w & (y[5] | y[3]); // Next state for y[0]
        // State B (y[1]) can transition to C (y[2]) when w is 0
        nextState[1] = w & y[0]; // Next state for y[1]
        // State C (y[2]) can transition to E (y[4]) when w is 1
        nextState[2] = ~w & y[1]; // Next state for y[2]
        // State D (y[3]) can be reached from states B, C, E, and F when w is 0
        nextState[3] = ~w & (y[1] | y[2] | y[4] | y[5]); // Next state for y[3]
        // State E (y[4]) can transition to D (y[3]) when w is 0
        nextState[4] = w & y[2]; // Next state for y[4]
        // State F (y[5]) can transition to C (y[2]) when w is 1
        nextState[5] = w & y[4]; // Next state for y[5]
    end

endmodule

module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    wire [5:0] nextState;

    CentralizedController controller(.y(y), .w(w), .nextState(nextState));

    // Assign the next-state values for Y1 and Y3
    always @(*) begin
        Y1 = nextState[1];
        Y3 = nextState[3];
    end

endmodule