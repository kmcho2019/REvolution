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

// Modes
localparam MODE_WALK  = 2'd0;
localparam MODE_DIG   = 2'd1;
localparam MODE_FALL  = 2'd2;
localparam MODE_SPLAT = 2'd3;

// Directions
localparam DIR_LEFT  = 1'b0;
localparam DIR_RIGHT = 1'b1;

reg [1:0] mode, next_mode;
reg direction, next_direction; // 0=left,1=right
reg [4:0] fall_timer, next_fall_timer; // count falling cycles

// Asynchronous reset + state update
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        direction <= DIR_LEFT; // walk left on reset
        fall_timer <= 5'd0;
    end else begin
        mode <= next_mode;
        // Update direction only if changed to reduce toggling
        if (direction != next_direction)
            direction <= next_direction;
        // Update fall_timer only if changed
        if (fall_timer != next_fall_timer)
            fall_timer <= next_fall_timer;
    end
end

// Next state logic
always_comb begin
    // Defaults keep current state and timer
    next_mode = mode;
    next_direction = direction;
    next_fall_timer = fall_timer;

    case (mode)
        MODE_SPLAT: begin
            // Stays splatted until reset
            next_mode = MODE_SPLAT;
            next_fall_timer = 5'd0;
        end

        MODE_FALL: begin
            if (ground) begin
                // Landed
                if (fall_timer > 5'd20) begin
                    next_mode = MODE_SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                end
                // direction unchanged
                next_direction = direction;
            end else begin
                // Falling: increment timer, saturate at 31
                next_mode = MODE_FALL;
                next_fall_timer = (fall_timer < 5'd31) ? (fall_timer + 5'd1) : fall_timer;
                next_direction = direction;
            end
        end

        MODE_WALK: begin
            if (!ground) begin
                // Fall has highest precedence
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else if (dig) begin
                // Digging second precedence; only if on ground and walking
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                // Handle bump for direction with priority:
                // Both bumped: toggle direction
                // else bump_left: walk right
                // else bump_right: walk left
                // else keep direction
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;
                if (bump_left && bump_right) begin
                    next_direction = ~direction;
                end else if (bump_left) begin
                    next_direction = DIR_RIGHT;
                end else if (bump_right) begin
                    next_direction = DIR_LEFT;
                end else begin
                    next_direction = direction;
                end
            end
        end

        MODE_DIG: begin
            if (!ground) begin
                // Falling overrides digging on ground loss
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else begin
                // Continue digging; bumps or dig input ignored during dig
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end

        default: begin
            // Safety: reset to walking left
            next_mode = MODE_WALK;
            next_direction = DIR_LEFT;
            next_fall_timer = 5'd0;
        end
    endcase
end

// Outputs reflect Moore FSM outputs from registered state/direction
assign walk_left  = (mode == MODE_WALK) && (direction == DIR_LEFT);
assign walk_right = (mode == MODE_WALK) && (direction == DIR_RIGHT);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule