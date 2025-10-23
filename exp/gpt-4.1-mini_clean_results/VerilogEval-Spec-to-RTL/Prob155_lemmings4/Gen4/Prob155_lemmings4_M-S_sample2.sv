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

localparam MODE_WALK = 2'd0;
localparam MODE_DIG  = 2'd1;
localparam MODE_FALL = 2'd2;
localparam MODE_SPLAT= 2'd3;

reg [1:0] mode, next_mode;
reg direction, next_direction; // 0=left, 1=right
reg [4:0] fall_timer, next_fall_timer; // count falling cycles

// Async reset and state update
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

always_comb begin
    // Defaults
    next_mode = mode;
    next_direction = direction;
    next_fall_timer = fall_timer;

    case (mode)
        MODE_SPLAT: begin
            // Remain splatted forever
            next_mode = MODE_SPLAT;
            next_fall_timer = 5'd0;
            // direction irrelevant
        end

        MODE_FALL: begin
            if (ground) begin
                if (fall_timer > 5'd20) begin
                    next_mode = MODE_SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                end
                next_direction = direction; // maintain walking direction
            end else begin
                next_mode = MODE_FALL;
                // Increment fall timer up to 21 to detect >20 cycles
                if (fall_timer < 5'd21)
                    next_fall_timer = fall_timer + 5'd1;
                else
                    next_fall_timer = fall_timer;
                next_direction = direction;
            end
        end

        MODE_WALK: begin
            if (!ground) begin
                // Fall starts
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else if (dig) begin
                // Start digging only if on ground and walking
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                // Handle bumps with direction logic
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;
                if (bump_left && bump_right) begin
                    // Both bumps: toggle direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // bump left => walk right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // bump right => walk left
                    next_direction = 1'b0;
                end else begin
                    next_direction = direction;
                end
            end
        end

        MODE_DIG: begin
            if (!ground) begin
                // start falling when ground disappears during digging
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else begin
                // keep digging on ground regardless of bumps/dig input
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end

        default: begin
            // Safe default: walk left
            next_mode = MODE_WALK;
            next_direction = 1'b0;
            next_fall_timer = 5'd0;
        end
    endcase
end

assign walk_left = (mode == MODE_WALK) && (direction == 1'b0);
assign walk_right= (mode == MODE_WALK) && (direction == 1'b1);
assign aaah      = (mode == MODE_FALL);
assign digging   = (mode == MODE_DIG);

endmodule