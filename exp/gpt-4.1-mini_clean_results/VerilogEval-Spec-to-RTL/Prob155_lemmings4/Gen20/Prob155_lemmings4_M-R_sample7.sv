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

    // State encoding
    typedef enum logic [1:0] {
        WALK  = 2'd0,
        FALL  = 2'd1,
        DIG   = 2'd2,
        SPLAT = 2'd3
    } state_t;

    state_t state, next_state;
    logic direction, next_direction; // 0=left, 1=right

    // Fall counter saturating at 31
    logic [4:0] fall_count, next_fall_count;

    // Bump signals
    wire bump_both      = bump_left & bump_right;
    wire bump_only_left = bump_left & ~bump_right;
    wire bump_only_right= bump_right & ~bump_left;

    // Combinational next-state logic and direction
    always_comb begin
        // Default next values
        next_state = state;
        next_direction = direction;
        next_fall_count = fall_count;

        case (state)
            WALK: begin
                if (!ground) begin
                    // Start falling
                    next_state = FALL;
                    next_fall_count = 5'd1;
                    // direction unchanged
                end else if (dig) begin
                    // Start digging
                    next_state = DIG;
                    next_fall_count = 5'd0;
                    // direction unchanged
                end else begin
                    // Handle bumps only in WALK
                    next_state = WALK;
                    next_fall_count = 5'd0;
                    if (bump_both) begin
                        next_direction = ~direction;
                    end else if (bump_only_left) begin
                        next_direction = 1'b1; // walk right
                    end else if (bump_only_right) begin
                        next_direction = 1'b0; // walk left
                    end else begin
                        next_direction = direction;
                    end
                end
            end

            FALL: begin
                if (!ground) begin
                    // Continue falling, saturate counter
                    next_state = FALL;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 5'd1;
                    else
                        next_fall_count = fall_count;
                    // direction unchanged
                end else begin
                    // Landed on ground
                    if (fall_count > 5'd20) begin
                        // splatter
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                        // direction unchanged but irrelevant
                    end else begin
                        // resume walking same direction
                        next_state = WALK;
                        next_fall_count = 5'd0;
                    end
                end
                next_direction = direction;
            end

            DIG: begin
                if (!ground) begin
                    // Fall if ground disappears during dig
                    next_state = FALL;
                    next_fall_count = 5'd1;
                    // direction unchanged
                end else begin
                    next_state = DIG;
                    next_fall_count = 5'd0;
                    // direction unchanged
                end
                next_direction = direction;
            end

            SPLAT: begin
                // Stay splattered forever
                next_state = SPLAT;
                next_fall_count = 5'd0;
                next_direction = direction;
            end

            default: begin
                next_state = WALK;
                next_fall_count = 5'd0;
                next_direction = 1'b0; // left
            end
        endcase
    end

    // Sequential state and direction update, asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // left
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_count <= next_fall_count;
        end
    end

    // Outputs (Moore)
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule