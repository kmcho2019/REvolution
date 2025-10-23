module TopModule (
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

    typedef enum logic [2:0] {
        WALK_L    = 3'd0,
        WALK_R    = 3'd1,
        DIG_L     = 3'd2,
        DIG_R     = 3'd3,
        FALL_L    = 3'd4,
        FALL_R    = 3'd5,
        SPLAT     = 3'd6
    } state_t;

    state_t state, next_state;
    logic [5:0] fall_timer, next_fall_timer; // 6 bits for counting to 63 (sufficient)

    wire bumped = bump_left | bump_right;
    wire bumped_both = bump_left & bump_right;

    // Async reset sequential block
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_timer <= 6'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and fall_timer logic
    always @(*) begin
        // Default next values
        next_state = state;
        next_fall_timer = (state == FALL_L || state == FALL_R) ?
                            ((fall_timer == 6'd63) ? 6'd63 : fall_timer + 1) : 6'd0;

        case (state)
            WALK_L: begin
                if (!ground) begin
                    next_state = FALL_L;
                    next_fall_timer = 6'd1;
                end else if (dig) begin
                    next_state = DIG_L;
                    next_fall_timer = 6'd0;
                end else if (bumped) begin
                    // On bump priority: both or left bump -> walk right; right bump -> walk left
                    if (bumped_both || bump_left)
                        next_state = WALK_R;
                    else if (bump_right)
                        next_state = WALK_L; // stays walk left if bumped right (actually switches left)
                end
            end

            WALK_R: begin
                if (!ground) begin
                    next_state = FALL_R;
                    next_fall_timer = 6'd1;
                end else if (dig) begin
                    next_state = DIG_R;
                    next_fall_timer = 6'd0;
                end else if (bumped) begin
                    if (bumped_both || bump_right)
                        next_state = WALK_L;
                    else if (bump_left)
                        next_state = WALK_R;
                end
            end

            DIG_L: begin
                if (!ground) begin
                    next_state = FALL_L;
                    next_fall_timer = 6'd1;
                end
                // Else continue digging, no direction change or fall timer increment
            end

            DIG_R: begin
                if (!ground) begin
                    next_state = FALL_R;
                    next_fall_timer = 6'd1;
                end
                // Else continue digging
            end

            FALL_L: begin
                if (ground) begin
                    if (fall_timer > 6'd20) begin
                        next_state = SPLAT;
                        next_fall_timer = 6'd0;
                    end else begin
                        next_state = WALK_L;
                        next_fall_timer = 6'd0;
                    end
                end
                // else remain falling and increment timer handled by default
            end

            FALL_R: begin
                if (ground) begin
                    if (fall_timer > 6'd20) begin
                        next_state = SPLAT;
                        next_fall_timer = 6'd0;
                    end else begin
                        next_state = WALK_R;
                        next_fall_timer = 6'd0;
                    end
                end
                // else remain falling and increment timer handled by default
            end

            SPLAT: begin
                // Remain splatted forever until reset
                next_state = SPLAT;
                next_fall_timer = 6'd0;
            end

            default: begin
                // Safety default to walking left
                next_state = WALK_L;
                next_fall_timer = 6'd0;
            end
        endcase
    end

    // Output decoding (Moore)
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);
    assign digging    = (state == DIG_L)  || (state == DIG_R);

endmodule