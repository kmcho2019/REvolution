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

    // Main states
    typedef enum logic {WALKING, FALLING} state_t;
    state_t current_state, next_state;
    
    // Direction states (only relevant in WALKING)
    typedef enum logic {LEFT, RIGHT} direction_t;
    direction_t current_dir, next_dir;
    
    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALKING;
            current_dir <= LEFT;
        end else begin
            current_state <= next_state;
            if (next_state == WALKING) begin
                current_dir <= next_dir;
            end
        end
    end
    
    // Next state logic
    always @(*) begin
        next_state = current_state;
        next_dir = current_dir;
        
        case (current_state)
            WALKING: begin
                if (!ground) begin
                    next_state = FALLING;
                end else begin
                    // Handle direction changes
                    if (bump_left && (current_dir == LEFT)) begin
                        next_dir = RIGHT;
                    end else if (bump_right && (current_dir == RIGHT)) begin
                        next_dir = LEFT;
                    end
                end
            end
            
            FALLING: begin
                if (ground) begin
                    next_state = WALKING;
                end
            end
        endcase
    end
    
    // Output logic (pure Moore)
    assign walk_left = (current_state == WALKING) && (current_dir == LEFT);
    assign walk_right = (current_state == WALKING) && (current_dir == RIGHT);
    assign aaah = (current_state == FALLING);
    
endmodule