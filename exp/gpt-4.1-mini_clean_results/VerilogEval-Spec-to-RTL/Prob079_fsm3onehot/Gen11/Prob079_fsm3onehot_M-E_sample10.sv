module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // Current states (one-hot)
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Define next state for in=0
    wire [3:0] next_state_in0;
    assign next_state_in0 = {D, C, B, A}; // {D,C,B,A} = {D,C,B,A} with bits ordered as [3:0]
    // From table: 
    // A->A=0001
    // B->C=0100
    // C->A=0001
    // D->C=0100
    // But listing per bit:
    // next_state_in0[3] (D next) = D's next for in=0 = D->C=0 (so D=0)
    // So more explicit:
    assign next_state_in0[0] = A | C; // A=1, C=1 next to A (bit 0)
    assign next_state_in0[1] = 1'b0;  // B=0
    assign next_state_in0[2] = B | D; // C next = from B or D
    assign next_state_in0[3] = 1'b0;  // D=0

    // Define next state for in=1
    wire [3:0] next_state_in1;
    // Next states for in=1 from table:
    // A->B=0010
    // B->B=0010
    // C->D=1000
    // D->B=0010
    assign next_state_in1[0] = 1'b0;
    assign next_state_in1[1] = A | B | D;
    assign next_state_in1[2] = 1'b0;
    assign next_state_in1[3] = C;

    // Multiplexer selecting between in=0 and in=1 next states
    assign next_state = in ? next_state_in1 : next_state_in0;

    // Output is '1' only when in state D
    assign out = D;

endmodule