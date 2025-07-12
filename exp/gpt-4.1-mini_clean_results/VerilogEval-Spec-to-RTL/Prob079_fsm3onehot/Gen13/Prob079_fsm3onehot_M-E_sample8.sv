module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // Declare intermediate wires for next state from each current state
    wire [3:0] next_if_A;
    wire [3:0] next_if_B;
    wire [3:0] next_if_C;
    wire [3:0] next_if_D;

    // One-hot state bits for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state when current is A
    assign next_if_A = (in == 1'b0) ? 4'b0001 : 4'b0010; // A->A if in=0 else B
    // Next state when current is B
    assign next_if_B = (in == 1'b0) ? 4'b0100 : 4'b0010; // B->C if in=0 else B
    // Next state when current is C
    assign next_if_C = (in == 1'b0) ? 4'b0001 : 4'b1000; // C->A if in=0 else D
    // Next state when current is D
    assign next_if_D = (in == 1'b0) ? 4'b0100 : 4'b0010; // D->C if in=0 else B

    // Combine the next states weighted by current active state (one-hot)
    assign next_state = (A ? next_if_A : 4'b0000) |
                        (B ? next_if_B : 4'b0000) |
                        (C ? next_if_C : 4'b0000) |
                        (D ? next_if_D : 4'b0000);

    // Output is high only in state D
    assign out = D;

endmodule