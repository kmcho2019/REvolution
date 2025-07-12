module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Moore output - depends only on current state
assign out = (state == 2'b11); // Output 1 when in state D (2'b11)

// Next state logic using ternary operators
assign next_state[1] = (state == 2'b00) ? 1'b0 :  // A -> 0 for both transitions
                      (state == 2'b01) ? ~in :    // B -> 1 if in=0 (C), 0 if in=1 (B)
                      (state == 2'b10) ? in :      // C -> 1 if in=1 (D), 0 if in=0 (A)
                      ~in;                         // D -> 1 if in=0 (C), 0 if in=1 (B)

assign next_state[0] = (state == 2'b00) ? in :     // A -> 1 if in=1 (B), 0 if in=0 (A)
                      (state == 2'b01) ? in :      // B -> 1 if in=1 (B), 0 if in=0 (C)
                      (state == 2'b10) ? in :      // C -> 1 if in=1 (D), 0 if in=0 (A)
                      ~in;                         // D -> 0 if in=1 (B), 1 if in=0 (C)

endmodule