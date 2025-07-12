module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Next state logic using continuous assignments
assign next_state[0] = (state == 2'b00 & in) |         // A->B when in=1
                      (state == 2'b01 & ~in) |         // B->C when in=0
                      (state == 2'b10 & in) |          // C->D when in=1
                      (state == 2'b11 & in);           // D->B when in=1

assign next_state[1] = (state == 2'b01 & ~in) |        // B->C when in=0
                      (state == 2'b10 & ~in) |        // C->A when in=0
                      (state == 2'b11 & ~in);         // D->C when in=0

// Output logic - only high in state D
assign out = (state == 2'b11);

endmodule