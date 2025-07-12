module CentralizedController(
    input  [5:0] y,
    input  w,
    output reg [5:0] nextState
);

    always @(*) begin
        // Directly set next states based on current state and input w
        // State A transitions to B when w = 1
        nextState[0] = ~w & (y[5] | y[3]);
        nextState[1] = w & y[0];
        nextState[2] = ~w & y[1];
        nextState[3] = ~w & (y[1] | y[2] | y[4] | y[5]);
        nextState[4] = w & y[2];
        nextState[5] = w & y[4];
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

    // Directly assign next-state values to outputs
    assign Y1 = nextState[1];
    assign Y3 = nextState[3];

endmodule