module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
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

    // Fall timer: count falling cycles (0 to >20)
    // 5 bits enough to count >20 (max 31)
    reg [4:0] fall_count;
    reg [4:0] next_fall_count;

    // Asynchronous posedge reset with clk
    // We use a reset register to catch posedge of areset.
    // Alternatively, since areset is asynchronous posedge, 
    // we implement in sensitivity list directly.

    // Using asynchronous posedge reset:
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // Next state and fall counter logic
    always @(*) begin
        // Default next values
        next_state = state;
        next_fall_count = fall_count;

        case(state)
            WALK_LEFT: begin
                // Priority: fall > dig > bump
                if (ground == 1'b0) begin
                    next_state = FALL_LEFT;
                    next_fall_count = 5'd1;
                end else if (dig == 1'b1) begin
                    next_state = DIG_LEFT;
                    next_fall_count = 5'd0;
                end else begin
                    // Check bump - if bumped on left or right or both, reverse direction
                    // bump on left => walk right
                    // bump on right => walk left
                    // both bump => reverse direction regardless
                    if (bump_left || bump_right) begin
                        next_state = WALK_RIGHT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_LEFT;
                        next_fall_count = 5'd0;
                    end
                end
            end

            WALK_RIGHT: begin
                // Priority: fall > dig > bump
                if (ground == 1'b0) begin
                    next_state = FALL_RIGHT;
                    next_fall_count = 5'd1;
                end else if (dig == 1'b1) begin
                    next_state = DIG_RIGHT;
                    next_fall_count = 5'd0;
                end else begin
                    if (bump_left || bump_right) begin
                        next_state = WALK_LEFT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_RIGHT;
                        next_fall_count = 5'd0;
                    end
                end
            end

            FALL_LEFT: begin
                // Increment fall count if still in air
                if (ground == 1'b0) begin
                    // continue falling
                    next_state = FALL_LEFT;
                    // Cap counter at max to avoid overflow - no wrap needed,
                    // since >20 is threshold, max is 31
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 5'd1;
                    else
                        next_fall_count = fall_count;
                end else begin
                    // ground reappeared, check fall count
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
                // Similar to FALL_LEFT
                if (ground == 1'b0) begin
                    next_state = FALL_RIGHT;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 5'd1;
                    else
                        next_fall_count = fall_count;
                end else begin
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
                // Digging only continues if ground=1
                // If ground=0, fall in same direction
                if (ground == 1'b0) begin
                    next_state = FALL_LEFT;
                    next_fall_count = 5'd1;
                end else begin
                    // Continue digging
                    next_state = DIG_LEFT;
                    next_fall_count = 5'd0;
                end
            end

            DIG_RIGHT: begin
                if (ground == 1'b0) begin
                    next_state = FALL_RIGHT;
                    next_fall_count = 5'd1;
                end else begin
                    next_state = DIG_RIGHT;
                    next_fall_count = 5'd0;
                end
            end

            SPLAT: begin
                // Forever splattered
                next_state = SPLAT;
                next_fall_count = 5'd0;
            end

            default: begin
                next_state = WALK_LEFT;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Outputs are purely from state (Moore)
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;

        case(state)
            WALK_LEFT:  walk_left = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALL_LEFT, FALL_RIGHT: aaah = 1'b1;
            DIG_LEFT, DIG_RIGHT: digging = 1'b1;
            SPLAT: ; // all outputs 0
            default: ;
        endcase
    end

endmodule