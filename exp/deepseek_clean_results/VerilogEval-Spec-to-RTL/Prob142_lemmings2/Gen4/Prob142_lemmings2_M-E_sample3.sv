module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // Combined state encoding [falling][direction]
    // [0] = direction (0:left, 1:right)
    // [1] = falling state (0:walking, 1:falling)
    reg [1:0] state, next_state;
    
    // Edge detection for ground signal
    reg ground_prev;
    wire ground_falling = ground_prev && !ground;
    wire ground_rising = !ground_prev && ground;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            ground_prev <= 1'b1;
        else
            ground_prev <= ground;
    end
    
    // State transition logic
    always @(*) begin
        case (state[1])
            1'b0: begin // Walking state
                if (ground_falling) begin
                    next_state = {1'b1, state[0]}; // Enter falling, keep direction
                end
                else begin
                    // Priority: bump_right > bump_left
                    if (bump_right)
                        next_state = {1'b0, 1'b0}; // Switch to left
                    else if (bump_left)
                        next_state = {1'b0, 1'b1}; // Switch to right
                    else
                        next_state = state; // Maintain state
                end
            end
            1'b1: begin // Falling state
                if (ground_rising)
                    next_state = {1'b0, state[0]}; // Resume walking with saved direction
                else
                    next_state = state; // Keep falling
            end
        endcase
    end
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // Reset to walking left
        else
            state <= next_state;
    end
    
    // Output logic
    assign walk_left = ~state[1] & ~state[0]; // Walking and left
    assign walk_right = ~state[1] & state[0];  // Walking and right
    assign aaah = state[1];                   // Falling

endmodule