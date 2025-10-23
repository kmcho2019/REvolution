module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Temporary wires for next state calculation
    wire [9:0] next_state_temp [9:0];
    
    // Initialize all next state contributions to 0
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : next_state_init
            assign next_state_temp[i] = 10'b0;
        end
    endgenerate
    
    // Calculate next state contributions for each possible current state
    // S0 transitions
    assign next_state_temp[0] = state[0] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;
    
    // S1 transitions
    assign next_state_temp[1] = state[1] ? (in ? 10'b0000000100 : 10'b0000000001) : 10'b0;
    
    // S2 transitions
    assign next_state_temp[2] = state[2] ? (in ? 10'b0000001000 : 10'b0000000001) : 10'b0;
    
    // S3 transitions
    assign next_state_temp[3] = state[3] ? (in ? 10'b0000010000 : 10'b0000000001) : 10'b0;
    
    // S4 transitions
    assign next_state_temp[4] = state[4] ? (in ? 10'b0000100000 : 10'b0000000001) : 10'b0;
    
    // S5 transitions
    assign next_state_temp[5] = state[5] ? (in ? 10'b0001000000 : 10'b0010000000) : 10'b0;
    
    // S6 transitions
    assign next_state_temp[6] = state[6] ? (in ? 10'b0100000000 : 10'b1000000000) : 10'b0;
    
    // S7 transitions
    assign next_state_temp[7] = state[7] ? (in ? 10'b0100000000 : 10'b0000000001) : 10'b0;
    
    // S8 transitions
    assign next_state_temp[8] = state[8] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;
    
    // S9 transitions
    assign next_state_temp[9] = state[9] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;
    
    // Combine all next state contributions
    assign next_state = next_state_temp[0] | next_state_temp[1] | next_state_temp[2] | 
                       next_state_temp[3] | next_state_temp[4] | next_state_temp[5] | 
                       next_state_temp[6] | next_state_temp[7] | next_state_temp[8] | 
                       next_state_temp[9];
    
    // Output logic
    assign out1 = state[8] | state[9];  // S8 or S9 active
    assign out2 = state[7] | state[9];  // S7 or S9 active

endmodule