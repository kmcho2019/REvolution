module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Moore output - depends only on current state
assign out = (state == 2'b11); // Output 1 when in state D (2'b11)

// Next state logic using parallel ternary assignments
assign next_state[1] = (state == 2'b01 & ~in) |  // B->C when in=0
                      (state == 2'b10 & in)  |  // C->D when in=1
                      (state == 2'b11 & ~in);   // D->C when in=0

assign next_state[0] = (state == 2'b00 & in) |  // A->B when in=1
                       (state == 2'b01 & in)  |  // B->B when in=1
                       (state == 2'b11 & in);    // D->B when in=1

endmodule