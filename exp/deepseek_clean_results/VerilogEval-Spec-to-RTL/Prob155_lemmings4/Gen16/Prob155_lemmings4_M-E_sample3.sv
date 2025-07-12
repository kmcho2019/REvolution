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

    // Action states
    typedef enum logic [1:0] {
        WALK,
        FALL,
        DIG,
        SPLAT
    } action_state_t;
    
    action_state_t curr_action, next_action;
    
    // Direction states
    typedef enum logic {
        LEFT,
        RIGHT
    } direction_t;
    
    direction_t curr_dir, next_dir;
    
    // Fall timer (5 bits for counting up to 20)
    logic [4:0] fall_count;
    logic timer_overflow;
    
    assign timer_overflow = (fall_count > 20);
    
    // State transition logic
    always_comb begin
        // Default: maintain current state
        next_action = curr_action;
        next_dir = curr_dir;
        
        case (curr_action)
            WALK: begin
                if (~ground) begin
                    next_action = FALL;
                end else if (dig) begin
                    next_action = DIG;
                end else begin
                    // Only change direction when walking
                    if (bump_left && (curr_dir == LEFT)) begin
                        next_dir = RIGHT;
                    end else if (bump_right && (curr_dir == RIGHT)) begin
                        next_dir = LEFT;
                    end
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_action = timer_overflow ? SPLAT : WALK;
                end
            end
            
            DIG: begin
                if (~ground) begin
                    next_action = FALL;
                end
            end
            
            SPLAT: begin
                // Stay in splat state forever
                next_action = SPLAT;
            end
        endcase
    end
    
    // Sequential logic
    always_ff @(posedge clk, posedge areset) begin
        if (areset) begin
            curr_action <= WALK;
            curr_dir <= LEFT;
            fall_count <= 0;
        end else begin
            curr_action <= next_action;
            curr_dir <= next_dir;
            
            // Fall timer logic
            if (curr_action != FALL) begin
                fall_count <= 0;
            end else if (~ground) begin
                fall_count <= fall_count + 1;
            end
        end
    end
    
    // Output logic
    assign walk_left = (curr_action == WALK) && (curr_dir == LEFT);
    assign walk_right = (curr_action == WALK) && (curr_dir == RIGHT);
    assign aaah = (curr_action == FALL);
    assign digging = (curr_action == DIG);
    
endmodule