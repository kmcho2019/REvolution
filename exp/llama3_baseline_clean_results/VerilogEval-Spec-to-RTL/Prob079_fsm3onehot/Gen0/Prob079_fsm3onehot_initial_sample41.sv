module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic equation
    // The output is 1 only when the current state is D
    assign out = state[3];  // out = 1 when state is D (4'b1000)

    // Next state logic equations
    // Next state is A when current state is A and in=0, or current state is C and in=0
    // Next state is B when current state is A and in=1, or current state is B and in=1, or current state is D and in=1
    // Next state is C when current state is B and in=0, or current state is D and in=0
    // Next state is D when current state is C and in=1

    assign next_state[0] = (~in) & ((state[0]) | (state[2]));  // Next state is A
    assign next_state[1] = (in) & ((state[0]) | (state[1]) | (state[3])) | (~in) & (state[1]);  // Next state is B
    assign next_state[2] = (~in) & (state[1]) | (~in) & (state[3]);  // Next state is C
    assign next_state[3] = (in) & (state[2]);  // Next state is D

endmodule