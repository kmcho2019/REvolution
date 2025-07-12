module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Output logic - direct from output states
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

// State group detection
wire counting_states = |state[4:0];    // S0-S4
wire special_states = |state[6:5];     // S5-S6
wire output_states = |state[9:7];      // S7-S9

// Shared counting logic
wire [2:0] count_val = 
    (state[0] & in) ? 3'd1 :  // S0->S1
    (state[1] & in) ? 3'd2 :  // S1->S2
    (state[2] & in) ? 3'd3 :  // S2->S3
    (state[3] & in) ? 3'd4 :  // S3->S4
    (state[4] & in) ? 3'd5 :  // S4->S5
    3'd0;

// Next state generation
assign next_state[0] = (~in & counting_states) |  // Counting states reset
                      (~in & output_states) |     // Output states reset
                      (~in & special_states);     // Special states reset

assign next_state[1] = (state[0] & in) |         // S0->S1
                      (output_states & in);      // S7-S9->S1

assign next_state[2] = (count_val == 3'd2);
assign next_state[3] = (count_val == 3'd3);
assign next_state[4] = (count_val == 3'd4);
assign next_state[5] = (count_val == 3'd5);

assign next_state[6] = (state[5] & in) |         // S5->S6
                      (state[6] & in);           // S6->S7 (but S6->S7 is actually S6->S7)

assign next_state[7] = (state[6] & in) |         // S6->S7
                      (state[7] & in);           // S7->S7

assign next_state[8] = (state[5] & ~in);         // S5->S8
assign next_state[9] = (state[6] & ~in);         // S6->S9

endmodule