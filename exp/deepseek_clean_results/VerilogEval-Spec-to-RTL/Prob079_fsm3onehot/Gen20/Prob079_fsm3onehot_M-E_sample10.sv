module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Bit-sliced state transition logic
    assign next_state[0] = (state == 4'b0001 & ~in) |  // A->A when in=0
                          (state == 4'b0100 & ~in);   // C->A when in=0

    assign next_state[1] = (state == 4'b0001 & in) |  // A->B when in=1
                          (state == 4'b0010 & in) |   // B->B when in=1
                          (state == 4'b1000 & in);    // D->B when in=1

    assign next_state[2] = (state == 4'b0010 & ~in) | // B->C when in=0
                          (state == 4'b1000 & ~in);   // D->C when in=0

    assign next_state[3] = (state == 4'b0100 & in);   // C->D when in=1

    // Output is high only in state D
    assign out = state[3];

endmodule