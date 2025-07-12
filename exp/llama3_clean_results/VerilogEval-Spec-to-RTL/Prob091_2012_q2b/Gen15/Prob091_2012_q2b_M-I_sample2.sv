module CentralizedController(
    input  [5:0] y,
    input  w,
    output reg [5:0] nextState
);

    // Simplify the next-state logic to minimize area and power
    always @(*) begin
        // State A transitions to B when w is 1
        nextState[0] = ~w & (y[5] | y[3]);
        
        // State B transitions to C when w is 0
        nextState[1] = w & y[0];
        
        // State C transitions to E when w is 1
        nextState[2] = ~w & y[1];
        
        // State D can be reached from B, C, E, and F when w is 0
        nextState[3] = ~w & (y[1] | y[2] | y[4] | y[5]);
        
        // State E transitions to D when w is 0
        nextState[4] = w & y[2];
        
        // State F transitions to C when w is 1
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

    // Directly assign the next-state values for Y1 and Y3
    assign Y1 = nextState[1];
    assign Y3 = nextState[3];

endmodule