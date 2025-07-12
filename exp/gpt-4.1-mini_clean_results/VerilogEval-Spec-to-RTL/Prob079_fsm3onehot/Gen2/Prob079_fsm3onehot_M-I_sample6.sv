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

    wire in_bar = ~in;

    // Common terms:
    wire in_and_A = A & in;
    wire in_and_B = B & in;
    wire in_and_D = D & in;

    wire in_bar_and_A = A & in_bar;
    wire in_bar_and_B = B & in_bar;
    wire in_bar_and_C = C & in_bar;
    wire in_bar_and_D = D & in_bar;

    wire in_and_C = C & in;

    // next_state bits (A, B, C, D)
    assign next_state[0] = in_bar_and_A | in_bar_and_C;                       // A
    assign next_state[1] = in_and_A | in_and_B | in_and_D;                   // B
    assign next_state[2] = in_bar_and_B | in_bar_and_D;                      // C
    assign next_state[3] = in_and_C;                                         // D

    assign out = D;

endmodule