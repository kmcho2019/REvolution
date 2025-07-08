module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding
    typedef enum logic [2:0] {
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        FALLING    = 3'd2,
        DIGGING    = 3'd3,
        SPLATTERED = 3'd4
    } state_t;

    state_t state, next_state;

    // Remember walking direction for returning after FALLING or DIGGING
    logic last_walk_left; // 1 means last walking left, 0 means last walking right

    // Fall counter: counts cycles spent falling
    logic [4:0] fall_count; // 5 bits to count up to >20

    // Asynchronous reset and state register
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            last_walk_left <= 1'b1;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            if (next_state == FALLING) begin
                // Increment fall counter if continuing falling, else start at 1
                if (state == FALLING)
                    fall_count <= fall_count + 5'd1;
                else
                    fall_count <= 5'd1;
            end else begin
                fall_count <= 5'd0;
            end

            // Update last_walk_left when walking states or digging (digging keeps last direction)
            // In FALLING or SPLATTERED, keep last_walk_left unchanged
            if (next_state == WALK_LEFT)
                last_walk_left <= 1'b1;
            else if (next_state == WALK_RIGHT)
                last_walk_left <= 1'b0;
            else if (next_state == DIGGING) begin
                // Keep last_walk_left unchanged
                // No assignment needed
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = state; // default hold
        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    // fall has precedence
                    next_state = FALLING;
                end else if (dig == 1'b1) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    // bump switches direction
                    // bump_left => walk right
                    // bump_right => walk left
                    // both bumps => still switch direction
                    // Since currently walking left, bump_left means bump from left side so walk right
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    next_state = FALLING;
                end else if (dig == 1'b1) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    // Currently walking right
                    // bump_right means bump from right side => walk left
                    // bump_left means bump from left side => walk right (so bump_right triggers change)
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                if (ground == 1'b0) begin
                    // Still falling, stay in FALLING
                    next_state = FALLING;
                end else begin
                    // ground=1 means landed
                    if (fall_count > 5'd20) begin
                        next_state = SPLATTERED;
                    end else begin
                        // resume walking in last direction
                        if (last_walk_left)
                            next_state = WALK_LEFT;
                        else
                            next_state = WALK_RIGHT;
                    end
                end
            end

            DIGGING: begin
                if (ground == 1'b0) begin
                    // No ground, start falling
                    next_state = FALLING;
                end else if (dig == 1'b1) begin
                    // Continue digging
                    next_state = DIGGING;
                end else begin
                    // If dig=0 and ground=1, but no instruction given in problem to stop digging explicitly,
                    // but digging stops only if dig=0? Problem states continue digging until ground=0 or dig=0?
                    // "will continue digging until it reaches other side (ground=0)" and "dig=1 to start digging"
                    // So if dig=0 while on ground, stop digging and return to walking in last direction?
                    // Problem says dig=1 to start, so dig=0 means stop digging
                    // So if dig=0 and ground=1, revert to walking in last direction
                    if (dig == 1'b0)
                        next_state = last_walk_left ? WALK_LEFT : WALK_RIGHT;
                    else
                        next_state = DIGGING; // just in case
                end
            end

            SPLATTERED: begin
                // forever stuck here
                next_state = SPLATTERED;
            end

            default: begin
                next_state = WALK_LEFT; // default fallback
            end
        endcase
    end

    // Moore outputs depend on state only
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule