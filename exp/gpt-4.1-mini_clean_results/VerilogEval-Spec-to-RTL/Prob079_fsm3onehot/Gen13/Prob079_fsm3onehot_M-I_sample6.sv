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

    // Factor input terms
    wire n0 = A | C;         // For next_state[0]
    wire n1 = A | B | D;     // For next_state[1]
    wire n2 = B | D;         // For next_state[2]
    // next_state[3] = in & C directly

    // Next state logic with factored input
    assign next_state[0] = in_n & n0;
    assign next_state[1] = in   & n1;
    assign next_state[2] = in_n & n2;
    assign next_state[3] = in   & C;

    // Output is high only when in state D
    assign out = D;

endmodule