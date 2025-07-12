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

    // State encoding (2 bits)
    localparam [1:0]
        WALK  = 2'd0,
        FALL  = 2'd1,
        DIG   = 2'd2,
        SPLAT = 2'd3;

    reg [1:0] state, next_state;
    reg       direction, next_direction;  // 0=left, 1=right
    reg [4:0] fall_count, next_fall_count; // saturating counter, max 31

    // Bump signals
    wire bump_both       = bump_left & bump_right;
    wire bump_only_left  = bump_left & ~bump_right;
    wire bump_only_right = bump_right & ~bump_left;

    // Next state and outputs logic
    always @(*) begin
        // Defaults: hold current values
        next_state      = state;
        next_direction  = direction;
        next_fall_count = fall_count;

        case(state)
            WALK: begin
                if (!ground) begin
                    // Start falling when ground disappears
                    next_state      = FALL;
                    next_fall_count = 5'd1;  // start counting fall duration
                    // direction unchanged
                end else if (dig) begin
                    // Start digging only if on ground and walking
                    next_state      = DIG;
                    next_fall_count = 5'd0;
                    // direction unchanged
                end else begin
                    // Walking on ground, handle bumps with priority
                    next_state      = WALK;
                    next_fall_count = 5'd0;
                    if (bump_both) begin
                        // Both bumps toggle direction
                        next_direction = ~direction;
                    end else if (bump_only_left) begin
                        // bump left: walk right
                        next_direction = 1'b1;
                    end else if (bump_only_right) begin
                        // bump right: walk left
                        next_direction = 1'b0;
                    end else begin
                        // No bump: maintain direction
                        next_direction = direction;
                    end
                end
            end

            FALL: begin
                if (!ground) begin
                    // Continue falling; saturate fall counter at 31
                    next_state = FALL;
                    next_direction = direction;
                    next_fall_count = (fall_count < 5'd31) ? fall_count + 1'b1 : fall_count;
                end else begin
                    // Landed on ground
                    if (fall_count > 5'd20) begin
                        // Splatter
                        next_state      = SPLAT;
                        next_fall_count = 5'd0;
                        // direction retained but irrelevant
                        next_direction  = direction;
                    end else begin
                        // Resume walking in same direction
                        next_state      = WALK;
                        next_fall_count = 5'd0;
                        next_direction  = direction;
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    // Ground disappeared while digging: start falling
                    next_state      = FALL;
                    next_fall_count = 5'd1;
                    // direction unchanged
                    next_direction  = direction;
                end else begin
                    // Continue digging on ground
                    next_state      = DIG;
                    next_fall_count = 5'd0;
                    // direction unchanged
                    next_direction  = direction;
                end
            end

            SPLAT: begin
                // Remain splatted forever, no outputs active
                next_state      = SPLAT;
                next_fall_count = 5'd0;
                next_direction  = direction;
            end

            default: begin
                // Safety: reset to walking left
                next_state      = WALK;
                next_fall_count = 5'd0;
                next_direction  = 1'b0;
            end
        endcase
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0;   // walk left after reset
            fall_count <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            fall_count <= next_fall_count;
        end
    end

    // Moore outputs depend only on current state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule