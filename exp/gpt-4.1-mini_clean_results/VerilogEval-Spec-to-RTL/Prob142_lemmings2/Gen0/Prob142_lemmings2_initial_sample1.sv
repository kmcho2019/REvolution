module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;

    // Store direction during FALLING to restore after fall
    state_t walking_dir;

    // Asynchronous reset and synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walking_dir <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update walking_dir only when in WALK states
            if (next_state == WALK_LEFT || next_state == WALK_RIGHT)
                walking_dir <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    // Start falling, preserve direction
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Change direction if bumped
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
                    // Back to walking, direction restored
                    next_state = walking_dir;
                end else begin
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic - Moore outputs depend only on state
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
                aaah       = 1'b0;
            end

            WALK_RIGHT: begin
                walk_left  = 1'b0;
                walk_right = 1'b1;
                aaah       = 1'b0;
            end

            FALLING: begin
                // walk_left and walk_right as before falling
                walk_left  = (walking_dir == WALK_LEFT) ? 1'b1 : 1'b0;
                walk_right = (walking_dir == WALK_RIGHT) ? 1'b1 : 1'b0;
                aaah       = 1'b1;
            end

            default: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
                aaah       = 1'b0;
            end
        endcase
    end

endmodule