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

// Output Y1 corresponds to next state B (y[1]) input
// Transition to B occurs only from state A (y[0]) when w = 1
assign Y1 = y[0] & w;

// Output Y3 corresponds to next state D (y[3]) input
// Transition to D occurs from states B, C, E, F when w = 0
assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule