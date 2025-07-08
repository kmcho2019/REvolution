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
    state_t prev_walk_state; // To remember walking direction before falling

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // If bumped on either side, switch direction to right
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // If bumped on either side, switch direction to left
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    // Return to previous walking direction when ground reappears
                    next_state = prev_walk_state;
                end
                // bumps during falling have no effect
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Sequential logic and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_walk_state <= WALK_LEFT;
        end else begin
            // If entering falling state, save previous walking state
            if (state != FALLING && next_state == FALLING) begin
                prev_walk_state <= state;
            end
            state <= next_state;
        end
    end

    // Output logic (Moore machine)
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        case(state)
            WALK_LEFT: walk_left = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING: aaah = 1'b1;
        endcase
    end

endmodule