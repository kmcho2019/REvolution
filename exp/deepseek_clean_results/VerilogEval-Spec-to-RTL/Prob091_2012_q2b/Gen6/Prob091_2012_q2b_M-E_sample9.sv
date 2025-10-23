module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state matrix (6 possible current states x 2 input values)
    // Format: next_state[5:0] = {F,E,D,C,B,A}
    wire [5:0] next_state [0:5][0:1];
    
    // Initialize transition matrix
    assign next_state[0][0] = 6'b000001; // A -> A
    assign next_state[0][1] = 6'b000010; // A -> B
    assign next_state[1][0] = 6'b001000; // B -> D
    assign next_state[1][1] = 6'b000100; // B -> C
    assign next_state[2][0] = 6'b001000; // C -> D
    assign next_state[2][1] = 6'b010000; // C -> E
    assign next_state[3][0] = 6'b000001; // D -> A
    assign next_state[3][1] = 6'b100000; // D -> F
    assign next_state[4][0] = 6'b001000; // E -> D
    assign next_state[4][1] = 6'b010000; // E -> E
    assign next_state[5][0] = 6'b001000; // F -> D
    assign next_state[5][1] = 6'b000100; // F -> C

    // Determine current state index (one-hot to binary)
    wire [2:0] curr_state_idx;
    assign curr_state_idx = 
        y[0] ? 3'd0 : 
        y[1] ? 3'd1 : 
        y[2] ? 3'd2 : 
        y[3] ? 3'd3 : 
        y[4] ? 3'd4 : 
        y[5] ? 3'd5 : 3'd0;

    // Select next state based on current state and input
    wire [5:0] selected_next_state;
    assign selected_next_state = next_state[curr_state_idx][w];

    // Extract Y1 and Y3 from next state
    assign Y1 = selected_next_state[1];
    assign Y3 = selected_next_state[3];

endmodule