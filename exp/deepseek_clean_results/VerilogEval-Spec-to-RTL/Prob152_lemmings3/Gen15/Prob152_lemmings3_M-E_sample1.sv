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

    // Movement states
    typedef enum logic [1:0] {
        M_WALK,
        M_FALL,
        M_DIG
    } movement_state_t;

    // Direction states
    typedef enum logic {
        D_LEFT,
        D_RIGHT
    } direction_state_t;

    movement_state_t curr_movement, next_movement;
    direction_state_t curr_dir, next_dir;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            curr_movement <= M_WALK;
            curr_dir <= D_LEFT;
        end else begin
            curr_movement <= next_movement;
            curr_dir <= next_dir;
        end
    end

    // Next state computation with explicit priority
    always_comb begin
        // Default: maintain current state
        next_movement = curr_movement;
        next_dir = curr_dir;

        // Priority-based state transitions
        case (curr_movement)
            M_WALK: begin
                if (!ground) begin
                    next_movement = M_FALL;
                end else if (dig) begin
                    next_movement = M_DIG;
                end else if (bump_left || bump_right) begin
                    next_dir = bump_left ? D_RIGHT : D_LEFT;
                end
            end

            M_FALL: begin
                if (ground) begin
                    next_movement = M_WALK;
                end
            end

            M_DIG: begin
                if (!ground) begin
                    next_movement = M_FALL;
                end
            end
        endcase
    end

    // Output generation
    assign walk_left  = (curr_movement == M_WALK) && (curr_dir == D_LEFT);
    assign walk_right = (curr_movement == M_WALK) && (curr_dir == D_RIGHT);
    assign aaah       = (curr_movement == M_FALL);
    assign digging    = (curr_movement == M_DIG);

endmodule