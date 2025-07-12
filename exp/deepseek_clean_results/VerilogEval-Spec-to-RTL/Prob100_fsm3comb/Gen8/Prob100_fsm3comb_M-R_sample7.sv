module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Output is 1 only in state D (2'b11)
assign out = (state == 2'b11);

// State transition logic using ternary operators
assign next_state[0] = (state == 2'b00) ? in :  // A->B when in=1
                      (state == 2'b01) ? 1'b1 :  // B stays B when in=1, goes to C[0] when in=0
                      (state == 2'b10) ? in :   // C->D when in=1
                      (state == 2'b11) ? 1'b1 : // D->B when in=1, goes to C[0] when in=0
                      1'b0;                     // default

assign next_state[1] = (state == 2'b00) ? 1'b0 : // A stays A when in=0
                      (state == 2'b01) ? ~in :   // B->C when in=0
                      (state == 2'b10) ? ~in :   // C->A when in=0
                      (state == 2'b11) ? ~in :   // D->C when in=0
                      1'b0;                     // default

endmodule