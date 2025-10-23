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

// Mode states (2 bits)
localparam MODE_WALK  = 2'b00;
localparam MODE_DIG   = 2'b01;
localparam MODE_FALL  = 2'b10;
localparam MODE_SPLAT = 2'b11;

reg [1:0] mode, next_mode;
reg direction, next_direction; // 0 = left, 1 = right

// Fall timer counts cycles in FALL mode, saturates at 31
reg [4:0] fall_timer, next_fall_timer;

wire bumped = bump_left | bump_right;
wire bump_both = bump_left & bump_right;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        direction <= 1'b0; // walk left after reset
        fall_timer <= 5'd0;
    end else begin
        mode <= next_mode;
        direction <= next_direction;
        fall_timer <= next_fall_timer;
    end
end

always @* begin
    // Defaults to current state/values
    next_mode = mode;
    next_direction = direction;
    next_fall_timer = fall_timer;

    case(mode)
        MODE_SPLAT: begin
            // Remain splatted forever, no changes
            next_mode = MODE_SPLAT;
            next_fall_timer = 5'd0;
            // direction unchanged
        end
        MODE_FALL: begin
            if (ground) begin
                // Landed: check splat condition (>20 cycles)
                if (fall_timer > 5'd20) begin
                    next_mode = MODE_SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                end
                // Direction unchanged on landing
                next_direction = direction;
            end else begin
                // Continue falling: increment timer (saturate at 31)
                next_mode = MODE_FALL;
                next_direction = direction;
                next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
            end
        end
        MODE_DIG: begin
            if (!ground) begin
                // Ground gone -> start falling, reset timer
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else begin
                // Continue digging; bumps ignored
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end
        MODE_WALK: begin
            if (!ground) begin
                // Falling takes precedence over digging
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else if (dig) begin
                // Dig only if on ground and not falling
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                // Walking on ground: bumps cause direction change
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;
                if (bump_both) begin
                    // Both bumps toggle direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // bumped on left => walk right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // bumped on right => walk left
                    next_direction = 1'b0;
                end else begin
                    next_direction = direction;
                end
            end
        end
        default: begin
            // Should never happen; safe reset to WALK left
            next_mode = MODE_WALK;
            next_direction = 1'b0;
            next_fall_timer = 5'd0;
        end
    endcase
end

// Moore output logic
assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule