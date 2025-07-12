module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // Decode current state bits for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];
    wire in_n = ~in;

    // Factored next state logic combining clarity and minimal gate usage
    assign next_state[0] = in_n & (A | C);       // next state A
    assign next_state[1] = in  & (A | B | D);    // next state B
    assign next_state[2] = in_n & (B | D);       // next state C
    assign next_state[3] = in  & C;               // next state D

    // Moore output logic: output only asserted in state D
    assign out = D;

endmodule