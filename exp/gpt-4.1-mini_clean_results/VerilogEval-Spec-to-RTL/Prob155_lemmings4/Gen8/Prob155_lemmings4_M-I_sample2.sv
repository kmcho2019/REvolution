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

// One-hot encoding for modes
localparam MODE_WALK_BIT = 4'b0001;
localparam MODE_DIG_BIT  = 4'b0010;
localparam MODE_FALL_BIT = 4'b0100;
localparam MODE_SPLAT_BIT= 4'b1000;

reg [3:0] mode, next_mode;
reg direction, next_direction; // 0=left,1=right
reg [4:0] fall_timer, next_fall_timer; // 5-bit fall timer

// Combine bump signals into a single bump flag for simpler logic
wire bump_both = bump_left & bump_right;
wire bump_any  = bump_left | bump_right;

wire splat_condition = (fall_timer > 5'd20);

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK_BIT;
        direction <= 1'b0; // walk left on reset
        fall_timer <= 5'd0;
    end else begin
        mode <= next_mode;
        if (direction != next_direction)
            direction <= next_direction;
        fall_timer <= next_fall_timer;
    end
end

// Enable fall timer increment only in fall mode to reduce toggling
wire fall_timer_en = (mode == MODE_FALL_BIT);

always_comb begin
    next_mode = mode;
    next_direction = direction;
    next_fall_timer = fall_timer;

    case (mode)
        MODE_SPLAT_BIT: begin
            // Stays splatted forever
            next_mode = MODE_SPLAT_BIT;
            next_fall_timer = 5'd0;
            // direction unchanged, no walking
        end

        MODE_FALL_BIT: begin
            if (ground) begin
                if (splat_condition) begin
                    next_mode = MODE_SPLAT_BIT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_mode = MODE_WALK_BIT;
                    next_fall_timer = 5'd0;
                end
                // direction unchanged
                next_direction = direction;
            end else begin
                // Continue falling and increment timer saturating at 31
                next_mode = MODE_FALL_BIT;
                next_direction = direction;
                next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
            end
        end

        MODE_WALK_BIT: begin
            if (!ground) begin
                next_mode = MODE_FALL_BIT;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else if (dig) begin
                next_mode = MODE_DIG_BIT;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                next_mode = MODE_WALK_BIT;
                next_fall_timer = 5'd0;
                // Improved bump logic:
                // If both bumps or bump_left: walk right (1)
                // else if bump_right: walk left (0)
                // else no change
                if (bump_both || bump_left) 
                    next_direction = 1'b1;
                else if (bump_right) 
                    next_direction = 1'b0;
                else 
                    next_direction = direction;
            end
        end

        MODE_DIG_BIT: begin
            if (!ground) begin
                next_mode = MODE_FALL_BIT;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else begin
                next_mode = MODE_DIG_BIT;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end

        default: begin
            next_mode = MODE_WALK_BIT;
            next_direction = 1'b0;
            next_fall_timer = 5'd0;
        end
    endcase
end

assign walk_left  = (mode == MODE_WALK_BIT) && (direction == 1'b0);
assign walk_right = (mode == MODE_WALK_BIT) && (direction == 1'b1);
assign aaah       = (mode == MODE_FALL_BIT);
assign digging    = (mode == MODE_DIG_BIT);

endmodule