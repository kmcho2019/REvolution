module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Next state logic using continuous assignments
assign next_state[1] = (state == 2'b00) ? 1'b0 :            // A -> 0 for both transitions
                      (state == 2'b01) ? ~in :              // B -> 1 if in=0, else 0
                      (state == 2'b10) ? in :               // C -> 1 if in=1, else 0
                      (state == 2'b11) ? ~in : 1'b0;        // D -> 1 if in=0, else 0

assign next_state[0] = (state == 2'b00) ? in :              // A -> 1 if in=1, else 0
                      (state == 2'b01) ? 1'b1 :            // B -> 1 for both transitions
                      (state == 2'b10) ? ~in :             // C -> 1 if in=0, else 0
                      (state == 2'b11) ? in : 1'b0;        // D -> 1 if in=1, else 0

// Output assignment remains the same
assign out = (state == 2'b11); // Output 1 only in state D

endmodule