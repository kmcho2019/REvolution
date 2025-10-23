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
        WLK_L = 3'd0,
        WLK_R = 3'd1,
        DIG_L = 3'd2,
        DIG_R = 3'd3,
        FALL_L = 3'd4,
        FALL_R = 3'd5,
        SPLAT  = 3'd6
    } state_t;

    state_t state, state_next;
    logic [4:0] fall_timer, fall_timer_next; // 5 bits: count up to 21 saturation

    // Sequential block with async reset: state and fall_timer update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK_L;
            fall_timer <= 5'd0;
        end else begin
            state <= state_next;
            fall_timer <= fall_timer_next;
        end
    end

    // Next state and fall timer calculation
    always_comb begin
        // Defaults
        state_next = state;
        fall_timer_next = fall_timer;

        case (state)
            SPLAT: begin
                // Remain splattered forever
                state_next = SPLAT;
                fall_timer_next = 5'd0;
            end

            // Walking Left
            WLK_L: begin
                if (ground == 1) begin
                    // On ground
                    if (dig) begin
                        // Start digging left
                        state_next = DIG_L;
                        fall_timer_next = 5'd0;
                    end else begin
                        // Check bumps with priority per spec
                        if (bump_left) begin
                            // Bumped left -> walk right
                            state_next = WLK_R;
                            fall_timer_next = 5'd0;
                        end else if (bump_right) begin
                            // Bumped right -> walk left
                            state_next = WLK_L;
                            fall_timer_next = 5'd0;
                        end else begin
                            // Continue walking left
                            state_next = WLK_L;
                            fall_timer_next = 5'd0;
                        end
                    end
                end else begin
                    // No ground - start falling left with timer=1
                    state_next = FALL_L;
                    fall_timer_next = 5'd1;
                end
            end

            // Walking Right
            WLK_R: begin
                if (ground == 1) begin
                    if (dig) begin
                        state_next = DIG_R;
                        fall_timer_next = 5'd0;
                    end else begin
                        // Check bumps with priority per spec
                        if (bump_right) begin
                            // Bumped right -> walk left
                            state_next = WLK_L;
                            fall_timer_next = 5'd0;
                        end else if (bump_left) begin
                            // Bumped left -> walk right
                            state_next = WLK_R;
                            fall_timer_next = 5'd0;
                        end else begin
                            state_next = WLK_R;
                            fall_timer_next = 5'd0;
                        end
                    end
                end else begin
                    state_next = FALL_R;
                    fall_timer_next = 5'd1;
                end
            end

            // Digging Left
            DIG_L: begin
                if (ground == 1) begin
                    // Continue digging left
                    state_next = DIG_L;
                    fall_timer_next = 5'd0;
                end else begin
                    // Ground gone - start falling left with timer=1
                    state_next = FALL_L;
                    fall_timer_next = 5'd1;
                end
            end

            // Digging Right
            DIG_R: begin
                if (ground == 1) begin
                    state_next = DIG_R;
                    fall_timer_next = 5'd0;
                end else begin
                    state_next = FALL_R;
                    fall_timer_next = 5'd1;
                end
            end

            // Falling Left
            FALL_L: begin
                if (ground == 0) begin
                    // Continue falling, increment timer with saturation at 21
                    state_next = FALL_L;
                    if (fall_timer < 5'd21)
                        fall_timer_next = fall_timer + 5'd1;
                    else
                        fall_timer_next = fall_timer;
                end else begin
                    // Ground reappeared - check fall duration
                    if (fall_timer > 5'd20) begin
                        state_next = SPLAT;
                        fall_timer_next = 5'd0;
                    end else begin
                        state_next = WLK_L;
                        fall_timer_next = 5'd0;
                    end
                end
            end

            // Falling Right
            FALL_R: begin
                if (ground == 0) begin
                    state_next = FALL_R;
                    if (fall_timer < 5'd21)
                        fall_timer_next = fall_timer + 5'd1;
                    else
                        fall_timer_next = fall_timer;
                end else begin
                    if (fall_timer > 5'd20) begin
                        state_next = SPLAT;
                        fall_timer_next = 5'd0;
                    end else begin
                        state_next = WLK_R;
                        fall_timer_next = 5'd0;
                    end
                end
            end

            // Default: reset to walking left (safe)
            default: begin
                state_next = WLK_L;
                fall_timer_next = 5'd0;
            end
        endcase
    end

    // Moore outputs
    assign walk_left  = (state == WLK_L);
    assign walk_right = (state == WLK_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);

endmodule