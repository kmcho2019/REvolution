module TopModule(
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

    // Next state logic for each state based on input 'in'
    // Since we are using one-hot encoding, each state can be represented by a single bit.
    // We will use the 'state' bits directly to simplify the logic.
    // A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000

    // If current state is A
    assign next_state[0] = (~in & state[0]) | (~in & ~state[0] & ~state[1] & ~state[2] & state[3]); // A to A if in=0, or D to A if in=0
    assign next_state[1] = (in & state[0]) | (in & state[1]); // A to B if in=1, or B to B if in=1
    assign next_state[2] = (~in & state[1]); // B to C if in=0
    assign next_state[3] = (in & state[2]) | (~in & ~state[0] & ~state[1] & ~state[2] & state[3]); // C to D if in=1, or D to C if in=0

    // Output logic
    // Output is 1 only for state D
    assign out = state[3];

endmodule