module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    wire in_n = ~in;

    assign next_state[0] = in_n & (A | C);           // A next state
    assign next_state[1] = in   & (A | B | D);       // B next state
    assign next_state[2] = in_n & (B | D);           // C next state
    assign next_state[3] = in   & C;                  // D next state

    assign out = D;

endmodule