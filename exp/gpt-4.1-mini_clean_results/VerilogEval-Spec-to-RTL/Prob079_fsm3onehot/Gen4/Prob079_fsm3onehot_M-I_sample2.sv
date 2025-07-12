module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot state bits
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Intermediate signals to share common terms and signals
    wire in_neg = ~in;
    wire ABorD = A | B | D;   // For next_state[1]
    wire AorC  = A | C;       // For next_state[0]
    wire BorD  = B | D;       // For next_state[2]

    // Next state logic (combinational) with factored terms:
    assign next_state[0] = AorC & in_neg;        // Next state A when (A or C) and in=0
    assign next_state[1] = in & ABorD;           // Next state B when in=1 and (A or B or D)
    assign next_state[2] = BorD & in_neg;        // Next state C when (B or D) and in=0
    assign next_state[3] = C & in;                // Next state D when C and in=1

    // Output is high only in state D (Moore output depends only on state)
    assign out = D;

endmodule