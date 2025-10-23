module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'd0,
        WALK_RIGHT = 2'd1,
        FALLING    = 2'd2
    } state_t;

    state_t state, next_state;
    logic last_walk_dir; // 0 = left, 1 = right

    // Sequential block: state register with asynchronous reset
    // Update last_walk_dir only when walking (current state WALK_LEFT or WALK_RIGHT)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            last_walk_dir <= 1'b0; // left
        end else begin
            state <= next_state;
            // Update last_walk_dir only if currently walking
            if (state == WALK_LEFT)
                last_walk_dir <= 1'b0;
            else if (state == WALK_RIGHT)
                last_walk_dir <= 1'b1;
            // Do not update last_walk_dir if FALLING
        end
    end

    // Next state logic
    always @* begin
        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Bump on any side switches direction
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                if (ground == 1'b1) begin
                    // Resume walking in last known direction
                    next_state = (last_walk_dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT; // safety default
        endcase
    end

    // Output logic (Moore)
    always @* begin
        walk_left  = (state == WALK_LEFT);
        walk_right = (state == WALK_RIGHT);
        aaah       = (state == FALLING);
    end

endmodule