module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Priority-encoded state transition logic
    wire [1:0] curr_state_encoded;
    assign curr_state_encoded = state[3] ? 2'b11 :
                               state[2] ? 2'b10 :
                               state[1] ? 2'b01 :
                               2'b00;  // state[0]

    assign next_state[0] = (curr_state_encoded == 2'b00 & ~in) |  // A stays if in=0
                          (curr_state_encoded == 2'b10 & ~in);    // C -> A if in=0

    assign next_state[1] = (curr_state_encoded == 2'b00 & in) |   // A -> B if in=1
                          (curr_state_encoded == 2'b01 & in) |    // B stays if in=1
                          (curr_state_encoded == 2'b11 & in);     // D -> B if in=1

    assign next_state[2] = (curr_state_encoded == 2'b01 & ~in) |  // B -> C if in=0
                          (curr_state_encoded == 2'b11 & ~in);    // D -> C if in=0

    assign next_state[3] = (curr_state_encoded == 2'b10 & in);    // C -> D if in=1

    // Output logic remains the same
    assign out = state[3];

endmodule