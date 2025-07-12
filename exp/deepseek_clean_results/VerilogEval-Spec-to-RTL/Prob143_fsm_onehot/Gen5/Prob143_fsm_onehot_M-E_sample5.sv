module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Priority-based state detection
    wire in_special_state = |state[9:7];
    wire [2:0] special_state = state[9] ? 3'b100 : 
                              state[8] ? 3'b010 : 
                              state[7] ? 3'b001 : 3'b000;

    // Next state logic with priority
    assign next_state[0] = (~in & (|state[9:0])) | 
                          (in & (state[0] | state[8] | state[9])) ? 1'b0 : 1'b0;
    
    assign next_state[1] = in & (state[0] | (special_state[1] | special_state[2]));
    assign next_state[2] = in & state[1] & ~in_special_state;
    assign next_state[3] = in & state[2] & ~in_special_state;
    assign next_state[4] = in & state[3] & ~in_special_state;
    assign next_state[5] = in & state[4] & ~in_special_state;
    assign next_state[6] = in & state[5] & ~in_special_state;
    assign next_state[7] = in & (state[6] | (state[7] & ~special_state[2]));
    assign next_state[8] = ~in & state[5] & ~in_special_state;
    assign next_state[9] = ~in & state[6] & ~in_special_state;

    // Correct next_state[0] with proper logic
    assign next_state[0] = (~in & (|state[9:0])) | 
                          (in & ((state[0] | state[8] | state[9]) & ~(|next_state[9:1])));

    // Priority-based output logic
    assign out1 = special_state[2] | (special_state[1] & ~special_state[2]);
    assign out2 = special_state[2] | special_state[0];

endmodule