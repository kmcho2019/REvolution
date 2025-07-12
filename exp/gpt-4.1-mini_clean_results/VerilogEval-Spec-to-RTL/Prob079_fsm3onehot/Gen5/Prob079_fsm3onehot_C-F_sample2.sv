module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // State encoding (one-hot):
    // A = state[0], B = state[1], C = state[2], D = state[3]

    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    wire in_n = ~in;

    // Group states to reduce fan-in and enable logic sharing
    wire AorC = A | C;         // For next_state[0]
    wire BorD = B | D;         // For next_state[2]
    wire AorBorD = A | B | D;  // For next_state[1]

    // Next state logic
    assign next_state[0] = in_n & AorC;      // Next state A
    assign next_state[1] = in   & AorBorD;   // Next state B
    assign next_state[2] = in_n & BorD;      // Next state C
    assign next_state[3] = in   & C;          // Next state D

    // Output logic (only high in state D)
    assign out = D;

endmodule