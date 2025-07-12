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

    // State encoding
    typedef enum logic [1:0] {
        MODE_WALK  = 2'd0,
        MODE_DIG   = 2'd1,
        MODE_FALL  = 2'd2,
        MODE_SPLAT = 2'd3
    } mode_t;

    mode_t mode, next_mode;
    logic direction, next_direction;  // 0=left, 1=right
    logic [4:0] fall_timer, next_fall_timer;

    // Combine bump signals
    wire bump = bump_left | bump_right;
    wire both_bump = bump_left & bump_right;

    // Next state combinational logic
    always_comb begin
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = fall_timer; // Default hold

        case(mode)
            MODE_SPLAT: begin
                // Remain splatted forever
                next_mode = MODE_SPLAT;
                next_direction = direction;
                next_fall_timer = 5'd0;
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
                    next_direction = direction;
                end else begin
                    // Continue falling with saturating counter at 31
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    // Only increment if less than max
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : (fall_timer + 5'd1);
                end
            end
            MODE_WALK: begin
                if (!ground) begin
                    // Start falling
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else if (dig) begin
                    // Start digging
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else if (bump) begin
                    // Change direction on bump:
                    // If both bump sides: invert direction
                    // Else if bumped left only: walk right (1)
                    // Else if bumped right only: walk left (0)
                    // Calculate direction update directly
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    if (both_bump)
                        next_direction = ~direction;
                    else if (bump_left)
                        next_direction = 1'b1;
                    else
                        next_direction = 1'b0;
                end else begin
                    // Continue walking same direction
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end
            MODE_DIG: begin
                if (!ground) begin
                    // Ground lost: start falling
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    // Continue digging
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end
            default: begin
                // Defensive reset to walk left
                next_mode = MODE_WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Sequential registers with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0; // walk left initially
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            // Update fall_timer only in fall mode to reduce toggling
            if (next_mode == MODE_FALL)
                fall_timer <= next_fall_timer;
            else
                fall_timer <= 5'd0;
        end
    end

    // Moore outputs
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule