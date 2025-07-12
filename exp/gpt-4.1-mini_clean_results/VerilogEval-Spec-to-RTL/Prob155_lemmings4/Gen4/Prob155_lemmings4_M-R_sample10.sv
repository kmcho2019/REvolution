module TopModule (
    input  clk,
    input  areset,       // asynchronous positive edge reset
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
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        FALL_LEFT  = 3'd2,
        FALL_RIGHT = 3'd3,
        DIG_LEFT   = 3'd4,
        DIG_RIGHT  = 3'd5,
        SPLAT      = 3'd6
    } state_t;

    state_t state, next_state;
    logic [4:0] fall_count, next_fall_count;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // Combine bump signals for direction switching detection
    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Extract direction from state
    wire dir_left = (state == WALK_LEFT) || (state == FALL_LEFT) || (state == DIG_LEFT);
    wire dir_right = (state == WALK_RIGHT) || (state == FALL_RIGHT) || (state == DIG_RIGHT);

    // Next state logic
    always @(*) begin
        next_state = state;
        next_fall_count = fall_count;

        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Start falling left
                    next_state = FALL_LEFT;
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    // Start digging left
                    next_state = DIG_LEFT;
                    next_fall_count = 5'd0;
                end else begin
                    // Walking on ground, check bumps
                    if (bump) begin
                        // Switch to walk right if bumped (left bump or right bump or both)
                        next_state = WALK_RIGHT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_LEFT;
                        next_fall_count = 5'd0;
                    end
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    // Start falling right
                    next_state = FALL_RIGHT;
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    // Start digging right
                    next_state = DIG_RIGHT;
                    next_fall_count = 5'd0;
                end else begin
                    if (bump) begin
                        // Switch to walk left if bumped
                        next_state = WALK_LEFT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_RIGHT;
                        next_fall_count = 5'd0;
                    end
                end
            end

            FALL_LEFT: begin
                if (!ground) begin
                    // Continue falling left with saturating counter
                    next_state = FALL_LEFT;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 1;
                    else
                        next_fall_count = fall_count;
                end else begin
                    // Landed from fall left
                    if (fall_count > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_LEFT;
                        next_fall_count = 5'd0;
                    end
                end
            end

            FALL_RIGHT: begin
                if (!ground) begin
                    // Continue falling right with saturating counter
                    next_state = FALL_RIGHT;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 1;
                    else
                        next_fall_count = fall_count;
                end else begin
                    // Landed from fall right
                    if (fall_count > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_RIGHT;
                        next_fall_count = 5'd0;
                    end
                end
            end

            DIG_LEFT: begin
                if (!ground) begin
                    // Hit edge, start falling left
                    next_state = FALL_LEFT;
                    next_fall_count = 5'd1;
                end else begin
                    // Continue digging left
                    next_state = DIG_LEFT;
                    next_fall_count = 5'd0;
                end
            end

            DIG_RIGHT: begin
                if (!ground) begin
                    // Hit edge, start falling right
                    next_state = FALL_RIGHT;
                    next_fall_count = 5'd1;
                end else begin
                    // Continue digging right
                    next_state = DIG_RIGHT;
                    next_fall_count = 5'd0;
                end
            end

            SPLAT: begin
                // Remain splatted forever
                next_state = SPLAT;
                next_fall_count = 5'd0;
            end

            default: begin
                next_state = WALK_LEFT;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Outputs depend solely on state (Moore FSM)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule