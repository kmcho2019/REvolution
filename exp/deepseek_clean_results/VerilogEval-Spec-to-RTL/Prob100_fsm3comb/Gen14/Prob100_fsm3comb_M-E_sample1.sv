module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Re-encoded states to minimize bit transitions:
// A=00, B=01, C=11, D=10
// This reduces bit flips for common transitions:
// A<->B (1 bit), B<->C (1 bit), C<->D (1 bit)

// Next state logic using bitwise operations
assign next_state[1] = (state == 2'b00) ? 1'b0 :        // A stays 0 or goes to B (01)
                      (state == 2'b01) ? ~in :         // B goes to C (11) or stays B (01)
                      (state == 2'b11) ? ~in :         // C goes to A (00) or D (10)
                      in;                              // D goes to C (11) or B (01)

assign next_state[0] = (state == 2'b00) ? in :         // A stays 0 or goes to B (01)
                      (state == 2'b01) ? 1'b1 :       // B goes to C (11) or stays B (01)
                      (state == 2'b11) ? 1'b0 :       // C goes to A (00) or D (10)
                      ~in;                            // D goes to C (11) or B (01)

// Output is simply MSB of state (since D=10 is the only state with output 1)
assign out = state[1] & ~state[0];  // Detect state D (10)

endmodule