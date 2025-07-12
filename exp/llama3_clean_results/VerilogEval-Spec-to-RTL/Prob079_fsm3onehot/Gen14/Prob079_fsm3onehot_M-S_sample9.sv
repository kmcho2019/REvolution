module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Directly use state bits for simplicity
    assign next_state = (state[0] && !in) ? 4'b0001 : // State A, in=0
                       (state[0] && in)  ? 4'b0010 : // State A, in=1
                       (state[1] && !in) ? 4'b0100 : // State B, in=0
                       (state[1] && in)  ? 4'b0010 : // State B, in=1
                       (state[2] && !in) ? 4'b0001 : // State C, in=0
                       (state[2] && in)  ? 4'b1000 : // State C, in=1
                       (state[3] && !in) ? 4'b0100 : // State D, in=0
                       (state[3] && in)  ? 4'b0010 : 4'bxxxx; // State D, in=1

    // Output logic remains straightforward
    assign out = state[3]; // Output is high when in state D

endmodule