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

    // Enumerated state encoding for clarity
    typedef enum logic [1:0] {
        WALK  = 2'd0,
        FALL  = 2'd1,
        DIG   = 2'd2,
        SPLAT = 2'd3
    } state_t;

    state_t state, next_state;
    logic dir, next_dir;           // 0 = left, 1 = right
    logic [4:0] fall_count, next_fall_count;

    // Sequential logic: state, dir, fall_count update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 1'b0;          // Initially walking left
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            dir <= next_dir;
            fall_count <= next_fall_count;
        end
    end

    // Next state and direction logic
    always @(*) begin
        // Default: hold current state, dir, fall_count
        next_state = state;
        next_dir = dir;
        next_fall_count = fall_count;

        case (state)
            WALK: begin
                if (!ground) begin
                    // Fall starts, reset fall count to 1
                    next_state = FALL;
                    next_fall_count = 5'd1;
                    next_dir = dir; // direction unchanged on fall start
                end else if (dig) begin
                    // Start digging only if on ground and walking
                    next_state = DIG;
                    next_fall_count = 5'd0;
                    next_dir = dir;
                end else begin
                    // Walk mode: handle bumps precisely
                    next_state = WALK;
                    next_fall_count = 5'd0;
                    if (bump_left && bump_right) begin
                        // Both bumps: toggle direction
                        next_dir = ~dir;
                    end else if (bump_left) begin
                        // Bump left: walk right
                        next_dir = 1'b1;
                    end else if (bump_right) begin
                        // Bump right: walk left
                        next_dir = 1'b0;
                    end else begin
                        // No bump: keep direction
                        next_dir = dir;
                    end
                end
            end

            FALL: begin
                if (ground) begin
                    // Landed, check splatter
                    if (fall_count > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK;
                        next_fall_count = 5'd0;
                    end
                    next_dir = dir;
                end else begin
                    // Continue falling, saturate fall_count at 31
                    next_state = FALL;
                    next_dir = dir;
                    next_fall_count = (fall_count < 5'd31) ? fall_count + 5'd1 : fall_count;
                end
            end

            DIG: begin
                if (!ground) begin
                    // Ground lost while digging: start falling
                    next_state = FALL;
                    next_fall_count = 5'd1;
                    next_dir = dir;
                end else begin
                    // Continue digging
                    next_state = DIG;
                    next_fall_count = 5'd0;
                    next_dir = dir;
                end
            end

            SPLAT: begin
                // Terminal splat state - no change
                next_state = SPLAT;
                next_dir = dir;
                next_fall_count = 5'd0;
            end

            default: begin
                // Safety fallback to WALK left
                next_state = WALK;
                next_dir = 1'b0;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Moore outputs: only one output active at a time as per state
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule