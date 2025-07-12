module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // Current states one-hot decoding
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next states based on input 'in'
    // Define next states separately for in=0 and in=1
    wire [3:0] next_state_in0;
    wire [3:0] next_state_in1;

    // For in=0 transitions:
    // A->A, B->C, C->A, D->C
    assign next_state_in0[0] = A | C;   // A bit
    assign next_state_in0[1] = 1'b0;    // B bit
    assign next_state_in0[2] = B | D;   // C bit
    assign next_state_in0[3] = 1'b0;    // D bit

    // For in=1 transitions:
    // A->B, B->B, C->D, D->B
    assign next_state_in1[0] = 1'b0;    // A bit
    assign next_state_in1[1] = A | B | D; // B bit
    assign next_state_in1[2] = 1'b0;    // C bit
    assign next_state_in1[3] = C;       // D bit

    // Select next_state based on input 'in'
    assign next_state = in ? next_state_in1 : next_state_in0;

    // Moore output: output = 1 only when in state D
    assign out = D;

endmodule