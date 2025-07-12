module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = 10'b0;
    
    // Initialize outputs to zero
    assign out1 = 0;
    assign out2 = 0;
    
    // Implement state transitions
    always @(*) begin
        // Transition from S0
        if (state[0] == 1) begin
            if (in == 0) begin
                next_state[0] = 1; // Stay in S0
            end else begin
                next_state[1] = 1; // Go to S1
            end
        end
        
        // Transition from S1
        if (state[1] == 1) begin
            if (in == 0) begin
                next_state[0] = 1; // Go to S0
            end else begin
                next_state[2] = 1; // Go to S2
            end
        end
        
        // Transition from S2
        if (state[2] == 1) begin
            if (in == 0) begin
                next_state[0] = 1; // Go to S0
            end else begin
                next_state[3] = 1; // Go to S3
            end
        end
        
        // Transition from S3
        if (state[3] == 1) begin
            if (in == 0) begin
                next_state[0] = 1; // Go to S0
            end else begin
                next_state[4] = 1; // Go to S4
            end
        end
        
        // Transition from S4
        if (state[4] == 1) begin
            if (in == 0) begin
                next_state[0] = 1; // Go to S0
            end else begin
                next_state[5] = 1; // Go to S5
            end
        end
        
        // Transition from S5
        if (state[5] == 1) begin
            if (in == 0) begin
                next_state[8] = 1; // Go to S8
            end else begin
                next_state[6] = 1; // Go to S6
            end
        end
        
        // Transition from S6
        if (state[6] == 1) begin
            if (in == 0) begin
                next_state[9] = 1; // Go to S9
            end else begin
                next_state[7] = 1; // Go to S7
            end
        end
        
        // Transition from S7
        if (state[7] == 1) begin
            if (in == 0) begin
                next_state[0] = 1; // Go to S0
            end else begin
                next_state[7] = 1; // Stay in S7
                out1 = 0;
                out2 = 1;
            end
        end
        
        // Transition from S8
        if (state[8] == 1) begin
            if (in == 0) begin
                next_state[0] = 1; // Go to S0
            end else begin
                next_state[1] = 1; // Go to S1
            end
            out1 = 1;
            out2 = 0;
        end
        
        // Transition from S9
        if (state[9] == 1) begin
            if (in == 0) begin
                next_state[0] = 1; // Go to S0
            end else begin
                next_state[1] = 1; // Go to S1
            end
            out1 = 1;
            out2 = 1;
        end
    end
    
endmodule