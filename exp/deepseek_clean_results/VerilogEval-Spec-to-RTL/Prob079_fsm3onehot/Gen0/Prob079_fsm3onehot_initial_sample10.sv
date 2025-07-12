module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State definitions (one-hot encoding)
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    // Next state logic
    assign next_state[0] = (state == A && ~in) || (state == C && ~in);  // Next A
    assign next_state[1] = (state == A && in) || (state == B && in) || (state == D && in);  // Next B
    assign next_state[2] = (state == B && ~in) || (state == D && ~in);  // Next C
    assign next_state[3] = (state == C && in);  // Next D

    // Output logic (Moore: output depends only on current state)
    assign out = (state == D);

endmodule