module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    typedef enum logic [1:0] {
        WALK_LEFT  = 2'd0,
        WALK_RIGHT = 2'd1,
        FALLING    = 2'd2
    } state_t;

    state_t state, next_state;
    state_t last_walk_state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            last_walk_state <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update last_walk_state only when walking (not falling)
            if (state == WALK_LEFT || state == WALK_RIGHT)
                last_walk_state <= state;
        end
    end

    // Next state logic (Moore FSM)
    always @* begin
        next_state = state;
        case(state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right) begin
                    // bumped on left or right or both, switch direction
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right) begin
                    // bumped on left or right or both, switch direction
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground)
                    next_state = last_walk_state; // resume walking in previous direction
                else
                    next_state = FALLING;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (Moore)
    always @* begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            FALLING: begin
                aaah = 1'b1;
            end
        endcase
    end

endmodule