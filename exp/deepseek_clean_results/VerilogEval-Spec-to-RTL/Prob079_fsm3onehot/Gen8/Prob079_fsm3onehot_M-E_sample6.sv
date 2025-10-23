module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State transition logic using priority encoding
    assign next_state[0] = (~in & state[0]) | (~in & state[2]);  // A <- A or C when in=0
    assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]);  // B <- A,B,D when in=1
    assign next_state[2] = (~in & state[1]) | (~in & state[3]) | (in & state[2]);  // C <- B,D when in=0 or C when in=1
    assign next_state[3] = in & state[2];  // D <- C when in=1

    // Output is directly the MSB of state (state D)
    assign out = state[3];

endmodule