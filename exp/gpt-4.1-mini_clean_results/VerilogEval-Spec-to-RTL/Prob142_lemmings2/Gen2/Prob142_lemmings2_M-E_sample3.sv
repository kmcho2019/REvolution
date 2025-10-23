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
    // Define states
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;

    // Registered inputs to synchronize bump and ground to clk domain,
    // so bumps simultaneous with ground change are sampled cleanly on posedge clk.
    reg bump_left_r, bump_right_r, ground_r, ground_rr;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            bump_left_r <= 1'b0;
            bump_right_r <= 1'b0;
            ground_r <= 1'b1;  // assume ground is initially present
            ground_rr <= 1'b1;
        end else begin
            bump_left_r <= bump_left;
            bump_right_r <= bump_right;
            ground_r <= ground;
            ground_rr <= ground_r;
        end
    end

    // Direction bit: 0=left,1=right
    // Always valid, even during falling to remember direction
    reg direction;

    // On reset set walking left, direction=0
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 1'b0;
        end else begin
            state <= next_state;
            // direction updates only when walking and bumped
            // in FALLING state direction remains unchanged
            if ((state == WALK_LEFT || state == WALK_RIGHT) && (bump_left_r || bump_right_r))
                direction <= ~direction;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            WALK_LEFT, WALK_RIGHT: begin
                // If ground lost, fall preserving direction
                if (ground_r == 1'b0)
                    next_state = FALLING;
                else if (bump_left_r || bump_right_r) begin
                    // Direction toggled in sequential block, update walking state accordingly
                    // Next state walking direction matches 'direction' after toggle
                    // Because direction update happens at posedge, here next_state uses inverted direction
                    // so invert direction to reflect toggle for next_state
                    if (direction == 1'b0)
                        next_state = WALK_RIGHT;
                    else
                        next_state = WALK_LEFT;
                end else begin
                    // No bump, stay in current walking state
                    next_state = state;
                end
            end
            FALLING: begin
                // If ground returns, go back to walking in stored direction
                if (ground_r == 1'b1) begin
                    if (direction == 1'b0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;

        case(state)
            WALK_LEFT:  walk_left = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah = 1'b1;
            default:    ;
        endcase
    end
endmodule