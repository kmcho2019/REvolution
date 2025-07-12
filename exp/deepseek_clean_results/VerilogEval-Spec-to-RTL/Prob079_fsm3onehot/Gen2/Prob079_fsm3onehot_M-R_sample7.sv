module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Next state logic using continuous assignments
    assign next_state[0] = (~state[0] & ~state[1] & ~state[2] & ~state[3]) |  // Default to A
                          (state[0] & ~in) |                                  // A stays A when in=0
                          (state[2] & ~in);                                   // C goes to A when in=0

    assign next_state[1] = (state[0] & in) |                                  // A goes to B when in=1
                           (state[1] & in) |                                  // B stays B when in=1
                           (state[3] & in);                                   // D goes to B when in=1

    assign next_state[2] = (state[1] & ~in) |                                 // B goes to C when in=0
                           (state[3] & ~in) |                                 // D goes to C when in=0
                           (state[2] & in);                                   // C goes to D when in=1

    assign next_state[3] = (state[2] & in);                                   // C goes to D when in=1

    // Output logic remains the same (Moore machine)
    assign out = state[3];

endmodule