module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    // Shared sub-expressions
    wire no_prev0 = ~in[0];
    wire no_prev1 = ~(|in[1:0]);
    wire no_prev2 = ~(|in[2:0]);

    // Combined priority detection and position encoding
    assign pos[0] = (in[1] & no_prev0) | (in[3] & no_prev2);
    assign pos[1] = (in[2] & no_prev1) | (in[3] & no_prev2);

endmodule