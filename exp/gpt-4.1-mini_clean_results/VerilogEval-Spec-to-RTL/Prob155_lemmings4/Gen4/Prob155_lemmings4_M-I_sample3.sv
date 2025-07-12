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

    typedef enum logic [1:0] {
        WALK  = 2'd0,
        FALL  = 2'd1,
        DIG   = 2'd2,
        SPLAT = 2'd3
    } state_t;

    state_t state, next_state;
    logic dir, next_dir;         // 0 = left, 1 = right
    logic [4:0] fall_count, next_fall_count;

    // Combined bump: any bump triggers direction flip
    wire bump = bump_left | bump_right;

    // Async reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 1'b0;       // walk left initially
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            dir <= next_dir;
            fall_count <= next_fall_count;
        end
    end

    always @(*) begin
        // Default: hold current values
        next_state = state;
        next_dir = dir;
        next_fall_count = fall_count;

        if (state == SPLAT) begin
            // Remain splatted forever
            next_state = SPLAT;
            next_dir = dir;
            next_fall_count = 5'd0;
        end else if (state == FALL) begin
            if (!ground) begin
                // Continue falling, saturate at 31
                next_state = FALL;
                next_dir = dir;
                next_fall_count = (fall_count == 5'd31) ? 5'd31 : fall_count + 1;
            end else begin
                // Landed: check splatter threshold (>20)
                if (fall_count > 5'd20) begin
                    next_state = SPLAT;
                    next_fall_count = 5'd0;
                    next_dir = dir;
                end else begin
                    next_state = WALK;
                    next_fall_count = 5'd0;
                    next_dir = dir;
                end
            end
        end else if (state == DIG) begin
            if (!ground) begin
                // Fall after reaching edge
                next_state = FALL;
                next_fall_count = 5'd1;
                next_dir = dir;
            end else begin
                // Continue digging
                next_state = DIG;
                next_fall_count = 5'd0;
                next_dir = dir;
            end
        end else /* state == WALK */ begin
            if (!ground) begin
                // Start falling
                next_state = FALL;
                next_fall_count = 5'd1;
                next_dir = dir; // direction unchanged while falling
            end else if (dig) begin
                // Start digging
                next_state = DIG;
                next_fall_count = 5'd0;
                next_dir = dir;
            end else begin
                // Walking and ground present
                next_state = WALK;
                next_fall_count = 5'd0;
                // Flip direction on any bump (left, right, or both)
                if (bump) begin
                    next_dir = ~dir;
                end else begin
                    next_dir = dir;
                end
            end
        end
    end

    // Moore outputs based on state and dir
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule