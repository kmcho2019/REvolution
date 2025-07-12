module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding using localparams for clarity
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Next state logic derived from truth table and minimized expressions
    // next_state[1] = (state == C & in) | (state == D & ~in)
    // next_state[0] = (state == A & in) | (state == B & in) | (state == D & in)
    assign next_state[1] = ((state == C) & in) | ((state == D) & ~in);
    assign next_state[0] = ((state == A) & in) | ((state == B) & in) | ((state == D) & in);

    // Output logic: out is 1 only in state D
    assign out = (state == D);

endmodule