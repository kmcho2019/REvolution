module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding parameters
    parameter A = 4'b0001,
              B = 4'b0010,
              C = 4'b0100,
              D = 4'b1000;

    // Consolidated state transition logic with optimal simplifications
    assign next_state = {
        in & state[2],               // next_state[3]: D (from C when in=1)
        ~in & (state[1] | state[3]),  // next_state[2]: C (from B or D when in=0)
        in & ~state[2],              // next_state[1]: B (from A,B,D when in=1 - simplified)
        ~in & (state[0] | state[2])   // next_state[0]: A (from A or C when in=0)
    };

    // Output is high only in state D (MSB of one-hot encoding)
    assign out = state[3];

endmodule