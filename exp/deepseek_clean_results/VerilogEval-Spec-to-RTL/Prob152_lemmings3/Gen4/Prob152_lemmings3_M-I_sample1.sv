module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);
    // One-hot state encoding
    parameter WALK = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG  = 3'b100;
    
    // Direction states
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg [2:0] state, next_state;
    reg direction, next_direction;
    reg ground_prev;
    
    // Fall detection (highest priority)
    wire falling_edge = ground_prev & ~ground;
    wire rising_edge = ~ground_prev & ground;
    wire should_fall = falling_edge | (~ground & (state[0] | state[2]));
    
    // State transition logic
    always @(*) begin
        next_state = state;
        next_direction = direction;
        
        case (1'b1) // synthesis parallel_case
            state[0]: begin // WALK
                if (should_fall) begin
                    next_state = FALL;
                end else if (dig & ground) begin
                    next_state = DIG;
                end else if ((bump_left & ~direction) | (bump_right & direction)) begin
                    next_direction = ~direction;
                end
            end
            
            state[1]: begin // FALL
                if (rising_edge) begin
                    next_state = WALK;
                end
            end
            
            state[2]: begin // DIG
                if (should_fall) begin
                    next_state = FALL;
                end
            end
        endcase
    end
    
    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= LEFT;
            ground_prev <= 1'b1;
        end else begin
            state <= next_state;
            if (state[0]) direction <= next_direction; // Only update in WALK state
            if (state[0] | state[2]) ground_prev <= ground; // Only sample when needed
        end
    end
    
    // Output logic - direct from state and direction
    assign walk_left = state[0] & ~direction;
    assign walk_right = state[0] & direction;
    assign aaah = state[1];
    assign digging = state[2];
    
endmodule