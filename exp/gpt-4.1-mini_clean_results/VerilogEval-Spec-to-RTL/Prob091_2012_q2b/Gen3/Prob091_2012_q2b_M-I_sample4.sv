module TopModule (
    input  wire [5:0] y,  // Current one-hot encoded state vector
    input  wire       w,  // FSM input
    output wire       Y1, // Next state input for flip-flop y[1] (state B)
    output wire       Y3  // Next state input for flip-flop y[3] (state D)
);

// State encoding (one-hot):
// y[0] = A
// y[1] = B
// y[2] = C
// y[3] = D
// y[4] = E
// y[5] = F

// Next state input for B (y[1]):
// Transition: A --1--> B
assign Y1 = y[0] & w;

// Next state input for D (y[3]):
// Transitions to D occur from B, C, E, F when w = 0
// Grouped ORs for potential gate optimization
wire BC = y[1] | y[2];
wire EF = y[4] | y[5];
assign Y3 = (~w) & (BC | EF);

endmodule