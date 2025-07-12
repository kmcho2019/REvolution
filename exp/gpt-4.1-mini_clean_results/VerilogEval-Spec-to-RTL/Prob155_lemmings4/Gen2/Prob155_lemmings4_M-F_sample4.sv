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
localparam MODE_WALK = 2'd0;
localparam MODE_DIG  = 2'd1;
localparam MODE_FALL = 2'd2;
localparam MODE_SPLAT= 2'd3;

reg [1:0] mode, next_mode;
reg direction, next_direction; // 0=left,1=right
reg [4:0] fall_timer, next_fall_timer; // count falling cycles

// Asynchronous reset + state update
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        direction <= 1'b0; // walk left on reset
        fall_timer <= 5'd0;
    end else begin
        mode <= next_mode;
        direction <= next_direction;
        fall_timer <= next_fall_timer;
    end
end

// Next state logic
always_comb begin
    // Defaults keep current state
    next_mode = mode;
    next_direction = direction;
    next_fall_timer = fall_timer;

    case (mode)
        MODE_SPLAT: begin
            // Stay splatted forever until reset
            next_mode = MODE_SPLAT;
            next_fall_timer = 5'd0;
            // direction doesn't matter
        end

        MODE_FALL: begin
            if (ground) begin
                // Landed on ground
                if (fall_timer > 5'd20) begin
                    // Splatter
                    next_mode = MODE_SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    // Resume walking same direction
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                end
            end else begin
                // Keep falling, increment timer but saturate at max 31
                next_mode = MODE_FALL;
                if (fall_timer < 5'd31)
                    next_fall_timer = fall_timer + 5'd1;
            end
            // direction unchanged while falling
            next_direction = direction;
        end

        MODE_WALK: begin
            if (!ground) begin
                // Fall start
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction; // keep direction
            end else if (dig) begin
                // Start digging only if on ground and walking
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else if (bump_left && bump_right) begin
                // Bumped both sides: switch direction (toggle)
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;
                next_direction = ~direction;
            end else if (bump_left) begin
                // Bumped left side: walk right
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;
                next_direction = 1'b1;
            end else if (bump_right) begin
                // Bumped right side: walk left
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;
                next_direction = 1'b0;
            end else begin
                // Continue walking
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end

        MODE_DIG: begin
            if (!ground) begin
                // Fall when ground lost during digging
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
            // Safety fallback reset to walking left
            next_mode = MODE_WALK;
            next_direction = 1'b0;
            next_fall_timer = 5'd0;
        end
    endcase
end

// Outputs
assign walk_left = (mode == MODE_WALK) && (direction == 1'b0);
assign walk_right= (mode == MODE_WALK) && (direction == 1'b1);
assign aaah      = (mode == MODE_FALL);
assign digging   = (mode == MODE_DIG);

endmodule