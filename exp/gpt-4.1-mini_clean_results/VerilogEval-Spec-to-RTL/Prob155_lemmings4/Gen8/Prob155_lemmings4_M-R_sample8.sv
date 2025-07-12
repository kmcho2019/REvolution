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

    // States enumeration
    typedef enum logic [1:0] {
        WALK  = 2'd0,
        FALL  = 2'd1,
        DIG   = 2'd2,
        SPLAT = 2'd3
    } state_t;

    // Registers for FSM state and direction
    reg [1:0] state, next_state;
    reg       direction, next_direction; // 0=left, 1=right

    // Fall counter (5 bits, saturates at 31)
    reg [4:0] fall_count, next_fall_count;

    // Synchronize asynchronous reset to clk domain for consistent reset
    reg reset_sync;
    always @(posedge clk or posedge areset) begin
        if (areset)
            reset_sync <= 1'b1;
        else
            reset_sync <= 1'b0;
    end

    // Bump signals combined for logic clarity
    wire bump_both       = bump_left & bump_right;
    wire bump_only_left  = bump_left & ~bump_right;
    wire bump_only_right = bump_right & ~bump_left;

    // State transition logic
    always @(*) begin
        // Defaults to hold current values
        next_state = state;
        next_fall_count = fall_count;
        next_direction = direction;

        case (state)
            WALK: begin
                if (!ground) begin
                    // Ground vanished, start FALL, count=1
                    next_state = FALL;
                    next_fall_count = 5'd1;
                    next_direction = direction; // direction preserved
                end else if (dig) begin
                    // Start DIG only on ground and walking
                    next_state = DIG;
                    next_fall_count = 5'd0;
                    next_direction = direction;
                end else begin
                    // No fall or dig; process bumps
                    next_state = WALK;
                    next_fall_count = 5'd0;
                    if (bump_both) begin
                        // Both bumps: toggle direction
                        next_direction = ~direction;
                    end else if (bump_only_left) begin
                        // Bump left -> walk right
                        next_direction = 1'b1;
                    end else if (bump_only_right) begin
                        // Bump right -> walk left
                        next_direction = 1'b0;
                    end else begin
                        next_direction = direction;
                    end
                end
            end
            FALL: begin
                if (!ground) begin
                    // Continue falling; increment count saturating at 31
                    next_state = FALL;
                    next_direction = direction;
                    next_fall_count = (fall_count < 5'd31) ? fall_count + 5'd1 : fall_count;
                end else begin
                    // Landed on ground, check splat threshold
                    if (fall_count > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                        next_direction = direction; // irrelevant
                    end else begin
                        next_state = WALK;
                        next_fall_count = 5'd0;
                        next_direction = direction;
                    end
                end
            end
            DIG: begin
                if (!ground) begin
                    // Ground disappeared during digging => FALL
                    next_state = FALL;
                    next_fall_count = 5'd1;
                    next_direction = direction;
                end else begin
                    // Continue digging
                    next_state = DIG;
                    next_fall_count = 5'd0;
                    next_direction = direction;
                end
            end
            SPLAT: begin
                // Remain splatted forever
                next_state = SPLAT;
                next_fall_count = 5'd0;
                next_direction = direction;
            end
            default: begin
                // Should never happen: reset to WALK left
                next_state = WALK;
                next_fall_count = 5'd0;
                next_direction = 1'b0;
            end
        endcase
    end

    // Sequential updates with synchronous reset
    always @(posedge clk) begin
        if (reset_sync) begin
            state <= WALK;
            direction <= 1'b0; // walk left on reset
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_count <= next_fall_count;
        end
    end

    // Moore outputs from current state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule