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

// Modes encoding (2 bits)
localparam MODE_WALK = 2'd0;
localparam MODE_DIG  = 2'd1;
localparam MODE_FALL = 2'd2;
localparam MODE_SPLAT= 2'd3;

reg [1:0] mode, next_mode;
reg direction, next_direction; // 0=left,1=right
reg [4:0] fall_timer, next_fall_timer; // 5-bit fall counter

// Async reset and sequential update
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        direction <= 1'b0; // Walk left after reset
        fall_timer <= 5'd0;
    end else begin
        mode <= next_mode;
        // Update direction only if it changes to reduce toggling
        if (next_direction != direction)
            direction <= next_direction;
        fall_timer <= next_fall_timer;
    end
end

// Combinational next state logic
always_comb begin
    // Default: hold current states
    next_mode = mode;
    next_direction = direction;
    next_fall_timer = fall_timer;

    case (mode)
        MODE_SPLAT: begin
            // Remain splattered forever until reset
            next_mode = MODE_SPLAT;
            next_fall_timer = 5'd0; // no counting needed
            // direction don't care here, no output walking
        end

        MODE_FALL: begin
            if (ground) begin
                // Lemming lands on ground after falling
                if (fall_timer >= 5'd21) begin
                    // Fell too long -> splatter
                    next_mode = MODE_SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    // Safe landing, resume walking same direction
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                end
                // direction stays same
                next_direction = direction;
            end else begin
                // Still falling: increment fall_timer, saturate at 31
                next_mode = MODE_FALL;
                next_direction = direction;
                if (fall_timer < 5'd31)
                    next_fall_timer = fall_timer + 5'd1;
                else
                    next_fall_timer = fall_timer;
            end
        end

        MODE_WALK: begin
            if (!ground) begin
                // Ground lost: start falling
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction; // direction unchanged
            end else if (dig) begin
                // Start digging on ground while walking
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                // Handle bumps explicitly
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;
                if (bump_left && bump_right) begin
                    // Both sides bumped: toggle direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // Bumped left, walk right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // Bumped right, walk left
                    next_direction = 1'b0;
                end else begin
                    // No bump, keep direction
                    next_direction = direction;
                end
            end
        end

        MODE_DIG: begin
            if (!ground) begin
                // Ground lost while digging -> start falling
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else begin
                // Continue digging on ground
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end

        default: begin
            // Failsafe: reset to walking left
            next_mode = MODE_WALK;
            next_direction = 1'b0;
            next_fall_timer = 5'd0;
        end
    endcase
end

// Moore outputs
assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule