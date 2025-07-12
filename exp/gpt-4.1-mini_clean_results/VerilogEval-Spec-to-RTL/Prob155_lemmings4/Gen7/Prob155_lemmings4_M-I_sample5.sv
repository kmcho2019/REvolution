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

// Modes encoding
localparam MODE_WALK = 2'd0;
localparam MODE_DIG  = 2'd1;
localparam MODE_FALL = 2'd2;
localparam MODE_SPLAT= 2'd3;

reg [1:0] mode, next_mode;
reg direction, next_direction; // 0=left,1=right
reg [4:0] fall_timer, next_fall_timer; // 5-bit fall timer

// Precompute splat condition
wire splat_condition = (fall_timer > 5'd20);

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        direction <= 1'b0; // walk left on reset
        fall_timer <= 5'd0;
    end else begin
        mode <= next_mode;
        // Update direction only when changed to reduce toggle
        if (direction != next_direction)
            direction <= next_direction;
        fall_timer <= next_fall_timer;
    end
end

always_comb begin
    // Defaults
    next_mode = mode;
    next_direction = direction;
    next_fall_timer = fall_timer;

    case (mode)
        MODE_SPLAT: begin
            // Stays splatted forever
            next_mode = MODE_SPLAT;
            next_fall_timer = 5'd0; // Timer irrelevant
            // Direction irrelevant, keep as is
        end

        MODE_FALL: begin
            if (ground) begin
                // Landed
                if (splat_condition) begin
                    next_mode = MODE_SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                end
                // Direction unchanged
                next_direction = direction;
            end else begin
                // Continue falling and increment timer saturating at 31
                next_mode = MODE_FALL;
                next_direction = direction;
                next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
            end
        end

        MODE_WALK: begin
            if (!ground) begin
                // Start falling
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction; // preserve direction
            end else if (dig) begin
                // Start digging only if on ground and walking
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                // Handle bumps carefully
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;
                if (bump_left && bump_right) begin
                    // Both bumps: toggle direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // bump left -> walk right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // bump right -> walk left
                    next_direction = 1'b0;
                end else begin
                    // no bump, no change
                    next_direction = direction;
                end
            end
        end

        MODE_DIG: begin
            if (!ground) begin
                // Fall when ground lost while digging
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else begin
                // Continue digging on ground, ignore bumps and dig input
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end

        default: begin
            // Safety fallback, reset walking left
            next_mode = MODE_WALK;
            next_direction = 1'b0;
            next_fall_timer = 5'd0;
        end
    endcase
end

// Outputs for Moore machine depend only on current mode and direction
assign walk_left = (mode == MODE_WALK) && (direction == 1'b0);
assign walk_right= (mode == MODE_WALK) && (direction == 1'b1);
assign aaah      = (mode == MODE_FALL);
assign digging   = (mode == MODE_DIG);

endmodule