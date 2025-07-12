module TopModule (
    input  clk,
    input  areset,       // asynchronous positive-edge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Enumerated states for clarity
    typedef enum logic [2:0] {
        WALK_L = 3'd0,
        WALK_R = 3'd1,
        FALL   = 3'd2,
        DIG    = 3'd3,
        SPLAT  = 3'd4
    } state_t;

    state_t state, next_state;

    // Fall counter: 6 bits to avoid overflow (max 63)
    // Counts falling cycles, saturates at 63
    logic [5:0] fall_count, next_fall_count;

    // Next state logic combinational process
    always @(*) begin
        // Defaults to hold current
        next_state = state;
        next_fall_count = fall_count;

        case(state)
            WALK_L, WALK_R: begin
                // Prioritize fall > dig > bump (only active in walk)
                if (!ground) begin
                    // Start falling, reset fall_count to 1
                    next_state = FALL;
                    next_fall_count = 6'd1;
                end else if (dig) begin
                    // Start digging if on ground and walking
                    next_state = DIG;
                    next_fall_count = 6'd0;
                end else begin
                    // Process bumps: bump both or either side switches direction
                    // Compute next walking direction based on bumps
                    if (bump_left & bump_right) begin
                        // Bumped both sides: reverse direction
                        next_state = (state == WALK_L) ? WALK_R : WALK_L;
                    end else if (bump_left) begin
                        // bumped left: walk right
                        next_state = WALK_R;
                    end else if (bump_right) begin
                        // bumped right: walk left
                        next_state = WALK_L;
                    end else begin
                        // no bump: stay same direction walk
                        next_state = state;
                    end
                    // fall_count remains zero during walking
                    next_fall_count = 6'd0;
                end
            end

            FALL: begin
                if (!ground) begin
                    // Continue falling, saturate counter at max 63
                    next_state = FALL;
                    next_fall_count = (fall_count < 6'd63) ? fall_count + 6'd1 : 6'd63;
                end else begin
                    // Landed: if fell too long, splatter, else resume walking same direction
                    if (fall_count > 6'd20) begin
                        next_state = SPLAT;
                        next_fall_count = 6'd0;
                    end else begin
                        // Resume walking in the same direction prior to fall
                        // Direction preserved in a separate reg so we map below in sequential
                        if (state == FALL) begin
                            // We need direction saved in separate reg: handled below
                        end
                        // Determine walking direction from stored direction bit
                        next_state = (fall_direction == 1'b0) ? WALK_L : WALK_R;
                        next_fall_count = 6'd0;
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    // No ground while digging -> start falling (fall count = 1)
                    next_state = FALL;
                    next_fall_count = 6'd1;
                end else begin
                    // Keep digging
                    next_state = DIG;
                    next_fall_count = 6'd0;
                end
            end

            SPLAT: begin
                // Remain splattered forever, no counter increment
                next_state = SPLAT;
                next_fall_count = 6'd0;
            end

            default: begin
                // Default recovery to walking left
                next_state = WALK_L;
                next_fall_count = 6'd0;
            end
        endcase
    end

    // Direction register: 
    // 0 = left, 1 = right
    // Updated only during walk or on falling start (saved for recovery)
    logic direction, next_direction;
    logic fall_direction; // to keep direction before falling to resume after

    always @(*) begin
        // Default hold
        next_direction = direction;
        fall_direction = direction;

        case(state)
            WALK_L: next_direction = 1'b0;
            WALK_R: next_direction = 1'b1;

            FALL: begin
                // direction saved before fall start, hold stable during fall
                fall_direction = direction;
                next_direction = direction;
            end

            DIG: begin
                // direction unchanged during digging
                next_direction = direction;
            end

            SPLAT: begin
                // direction doesn't matter after splat
                next_direction = direction;
            end
        endcase
    end

    // Sequential update and asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            direction <= 1'b0;
            fall_count <= 6'd0;
        end else begin
            // On landing from FALL state to WALK, restore direction accordingly
            if (state == FALL && next_state != FALL) begin
                // Use fall_direction to select walking direction
                direction <= fall_direction;
            end else if (next_state == WALK_L) begin
                direction <= 1'b0;
            end else if (next_state == WALK_R) begin
                direction <= 1'b1;
            end else begin
                direction <= direction; // Hold direction otherwise
            end

            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // Moore outputs
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule