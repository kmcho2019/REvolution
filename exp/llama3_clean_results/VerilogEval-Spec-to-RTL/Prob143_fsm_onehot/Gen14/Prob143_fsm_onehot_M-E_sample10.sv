module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    // Next state matrix: [current_state][input] -> next_state
    reg [9:0] next_state_matrix [10][2] = {
        {10'b0000000001, 10'b0000000010},  // S0
        {10'b0000000001, 10'b0000000100},  // S1
        {10'b0000000001, 10'b0000001000},  // S2
        {10'b0000000001, 10'b0000010000},  // S3
        {10'b0000000001, 10'b0000100000},  // S4
        {10'b0001000000, 10'b0000010000},  // S5
        {10'b0000100000, 10'b0000001000},  // S6
        {10'b0000000001, 10'b0000001000},  // S7
        {10'b0000000001, 10'b0000000010},  // S8
        {10'b0000000001, 10'b0000000010}   // S9
    };

    // Output matrix: [current_state][input] -> (out1, out2)
    reg [1:0] output_matrix [10][2] = {
        {2'b00, 2'b00},  // S0
        {2'b00, 2'b00},  // S1
        {2'b00, 2'b00},  // S2
        {2'b00, 2'b00},  // S3
        {2'b00, 2'b00},  // S4
        {2'b00, 2'b00},  // S5
        {2'b00, 2'b00},  // S6
        {2'b01, 2'b01},  // S7
        {2'b10, 2'b00},  // S8
        {2'b11, 2'b00}   // S9
    };

    always @(*) begin
        next_state = 10'b0; // Initialize next_state to zero
        out1 = 1'b0; // Initialize out1 to zero
        out2 = 1'b0; // Initialize out2 to zero

        // Find the current state
        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin
                // Determine the next state and output based on the current state and input
                next_state = next_state_matrix[i][in];
                {out2, out1} = output_matrix[i][in];
            end
        end
    end

endmodule