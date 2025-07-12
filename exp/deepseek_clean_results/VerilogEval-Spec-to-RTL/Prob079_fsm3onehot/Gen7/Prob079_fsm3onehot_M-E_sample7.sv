module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State transition logic using priority-encoder style
    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in);  // A <- A(in=0) or C(in=0)
    assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in);  // B <- A(in=1) or B(in=1) or D(in=1)
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in);  // C <- B(in=0) or D(in=0)
    assign next_state[3] = state[2] & in;                       // D <- C(in=1)

    // Output is simply the D state bit
    assign out = state[3];

endmodule