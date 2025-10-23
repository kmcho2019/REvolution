module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Parallel state predictors
    wire [3:0] from_A = {3'b000, state[0] & ~in};       // A stays if in=0
    wire [3:0] from_B = {2'b00, state[1] & ~in, 1'b0};  // B->C if in=0
    wire [3:0] from_C = {1'b0, state[2] & in, 1'b0, state[2] & ~in}; // C->D if in=1, C->A if in=0
    wire [3:0] from_D = {1'b0, state[3] & in, state[3] & ~in, 1'b0}; // D->B if in=1, D->C if in=0

    // Combine predictions (OR reduction)
    assign next_state = from_A | from_B | from_C | from_D;

    // Output is high only in state D (one-hot MSB)
    assign out = state[3];

endmodule