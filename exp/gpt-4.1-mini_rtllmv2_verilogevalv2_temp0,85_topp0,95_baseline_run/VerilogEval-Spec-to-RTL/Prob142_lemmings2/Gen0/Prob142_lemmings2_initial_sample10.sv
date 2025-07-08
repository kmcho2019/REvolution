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

    // Register to remember direction before falling
    state_t direction_before_fall;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction_before_fall <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update direction_before_fall when walking states
            if (ground && (state == WALK_LEFT || state == WALK_RIGHT))
                direction_before_fall <= state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // switch direction on any bump
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // switch direction on any bump
                    next_state = WALK_LEFT;
                end
            end

            FALLING: begin
                if (ground) begin
                    // Resume walking in previous direction
                    next_state = direction_before_fall;
                end
                // else stay falling
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic: Moore outputs depend on current state
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;

        case (state)
            WALK_LEFT:  walk_left  = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah       = 1'b1;
        endcase
    end

endmodule