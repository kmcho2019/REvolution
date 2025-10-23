module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // Extract one-hot current states
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic directly from state transition table:
    // next_state[0] = (A AND ~in) OR (C AND ~in)
    assign next_state[0] = (A & (~in)) | (C & (~in));
    
    // next_state[1] = (A AND in) OR (B AND in) OR (D AND in)
    assign next_state[1] = (A & in) | (B & in) | (D & in);
    
    // next_state[2] = (B AND ~in) OR (D AND ~in)
    assign next_state[2] = (B & (~in)) | (D & (~in));
    
    // next_state[3] = C AND in
    assign next_state[3] = C & in;

    // Output is 1 only in state D
    assign out = D;

endmodule