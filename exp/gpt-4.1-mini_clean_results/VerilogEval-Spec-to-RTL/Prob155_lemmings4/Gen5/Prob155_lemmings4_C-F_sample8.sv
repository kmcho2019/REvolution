module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
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
    logic dir, next_dir;         // 0 = left, 1 = right
    logic [4:0] fall_count, next_fall_count;

    // Asynchronous positive edge reset and synchronous updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            dir        <= 1'b0;   // start walking left
            fall_count <= 5'd0;
        end else begin
            state      <= next_state;
            dir        <= next_dir;
            fall_count <= next_fall_count;
        end
    end

    // Next state and registers logic
    always @(*) begin
        // Default to hold current values
        next_state      = state;
        next_dir        = dir;
        next_fall_count = fall_count;

        case (state)
            WALK: begin
                if (!ground) begin
                    // Ground lost: start falling, count=1
                    next_state      = FALL;
                    next_fall_count = 5'd1;
                    next_dir        = dir; // Direction unchanged
                end else if (dig) begin
                    // Start digging
                    next_state      = DIG;
                    next_fall_count = 5'd0;
                    next_dir        = dir;
                end else begin
                    // Walking on ground, handle bumps
                    next_state      = WALK;
                    next_fall_count = 5'd0;

                    // According to bump logic:
                    // If bump_left and bump_right, invert direction
                    // else if bump_left only, walk right (dir=1)
                    // else if bump_right only, walk left (dir=0)
                    // else keep direction
                    if (bump_left && bump_right) begin
                        next_dir = ~dir;
                    end else if (bump_left) begin
                        next_dir = 1'b1;  // walk right
                    end else if (bump_right) begin
                        next_dir = 1'b0;  // walk left
                    end else begin
                        next_dir = dir;
                    end
                end
            end

            FALL: begin
                if (!ground) begin
                    // Continue falling, saturate fall_count at 31
                    next_state      = FALL;
                    next_dir        = dir;
                    next_fall_count = (fall_count < 5'd31) ? (fall_count + 1) : fall_count;
                end else begin
                    // Landed: check splatter condition
                    if (fall_count > 5'd20) begin
                        next_state      = SPLAT;
                        next_fall_count = 5'd0;
                        next_dir        = dir; // not relevant after splat
                    end else begin
                        next_state      = WALK;
                        next_fall_count = 5'd0;
                        next_dir        = dir;
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    // Hit edge while digging → fall
                    next_state      = FALL;
                    next_fall_count = 5'd1;
                    next_dir        = dir;
                end else begin
                    // Continue digging
                    next_state      = DIG;
                    next_fall_count = 5'd0;
                    next_dir        = dir;
                end
            end

            SPLAT: begin
                // Remain splatted forever
                next_state      = SPLAT;
                next_fall_count = 5'd0;
                next_dir        = dir;
            end

            default: begin
                // Safe fallback
                next_state      = WALK;
                next_fall_count = 5'd0;
                next_dir        = 1'b0;
            end
        endcase
    end

    // Moore outputs derived combinationally from state and direction
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule