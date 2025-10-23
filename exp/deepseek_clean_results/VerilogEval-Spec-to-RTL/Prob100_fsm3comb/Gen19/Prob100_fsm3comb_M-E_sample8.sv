module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Next state computation as mathematical functions
assign next_state[1] = (state == 2'b01 & ~in) |  // B->C when in=0
                      (state == 2'b10 & in) |   // C->D when in=1
                      (state == 2'b11);         // D->C or D->B

assign next_state[0] = (state == 2'b00 & in) |  // A->B when in=1
                      (state == 2'b01) |        // B stays or goes to C
                      (state == 2'b11 & in);    // D->B when in=1

// Output is high only when in state D (2'b11)
assign out = &state;  // AND of both state bits (true only for 2'b11)

endmodule