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

    typedef enum logic [1:0] {
        WALK_LEFT  = 2'd0,
        WALK_RIGHT = 2'd1,
        FALL       = 2'd2,
        DIG        = 2'd3
    } state_t;

    state_t state, next_state;

    always @(*) begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left || bump_right) begin
                    // switch direction on any bump
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left || bump_right) begin
                    // switch direction on any bump
                    next_state = WALK_LEFT;
                end
            end

            FALL: begin
                if (ground) begin
                    // Resume walking in previous direction
                    // Determine by previous state encoded in variable:
                    // To do so, track direction as separate bit:
                    // but we don't have that yet, so store last walk direction in a reg
                    next_state = (last_walk_dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                end
            end

            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end
            end
        endcase
    end

    // Track last walking direction separately for fall state
    reg last_walk_dir;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            last_walk_dir <= 1'b0;
        end else begin
            state <= next_state;
            // Update last walk direction only when walking
            if (next_state == WALK_LEFT)
                last_walk_dir <= 1'b0;
            else if (next_state == WALK_RIGHT)
                last_walk_dir <= 1'b1;
        end
    end

    // Output signals as Moore outputs
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule