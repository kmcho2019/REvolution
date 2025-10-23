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
    
    // Direction states
    typedef enum logic {LEFT, RIGHT} dir_t;
    dir_t current_dir, next_dir;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALKING;
            current_dir <= LEFT;
        end else begin
            current_state <= next_state;
            if (current_state == WALKING) begin
                current_dir <= next_dir;
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            WALKING: if (!ground) next_state = FALLING;
            FALLING: if (ground) next_state = WALKING;
        endcase
    end

    // Direction change logic (only active during WALKING)
    always_comb begin
        next_dir = current_dir;
        if (current_state == WALKING) begin
            if (bump_left && !bump_right) next_dir = RIGHT;
            else if (bump_right && !bump_left) next_dir = LEFT;
            else if (bump_left && bump_right) next_dir = ~current_dir;
        end
    end

    // Output logic
    assign walk_left = (current_state == WALKING) && (current_dir == LEFT);
    assign walk_right = (current_state == WALKING) && (current_dir == RIGHT);
    assign aaah = (current_state == FALLING);

endmodule