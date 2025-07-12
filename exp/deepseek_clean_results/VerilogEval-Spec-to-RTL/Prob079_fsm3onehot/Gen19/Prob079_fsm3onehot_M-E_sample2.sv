module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Priority encoder for current state
    wire [1:0] curr_state_encoded;
    assign curr_state_encoded = 
        (state[3]) ? 2'b11 :
        (state[2]) ? 2'b10 :
        (state[1]) ? 2'b01 :
        2'b00;  // state[0] or none (default to A)

    // Next state logic using muxes
    assign next_state[0] = (curr_state_encoded == 2'b00) ? ~in :  // A->A when in=0
                          (curr_state_encoded == 2'b10) ? ~in :   // C->A when in=0
                          1'b0;
    
    assign next_state[1] = (curr_state_encoded == 2'b00) ? in :   // A->B when in=1
                          (curr_state_encoded == 2'b01) ? in :    // B->B when in=1
                          (curr_state_encoded == 2'b11) ? in :    // D->B when in=1
                          1'b0;
    
    assign next_state[2] = (curr_state_encoded == 2'b01) ? ~in :  // B->C when in=0
                          (curr_state_encoded == 2'b11) ? ~in :   // D->C when in=0
                          1'b0;
    
    assign next_state[3] = (curr_state_encoded == 2'b10) ? in :   // C->D when in=1
                          1'b0;

    // Output is simply state D
    assign out = state[3];

endmodule