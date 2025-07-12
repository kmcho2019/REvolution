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

// Mode encoding
localparam MODE_WALK  = 2'd0;
localparam MODE_DIG   = 2'd1;
localparam MODE_FALL  = 2'd2;
localparam MODE_SPLAT = 2'd3;

// Direction encoding
localparam DIR_LEFT  = 1'b0;
localparam DIR_RIGHT = 1'b1;

reg [1:0] mode, next_mode;
reg direction, next_direction;         // 0=left, 1=right
reg [4:0] fall_timer, next_fall_timer; // count up to 21

wire bumped = bump_left | bump_right;

// Next state combinational logic
always @(*) begin
    // Default next values are current
    next_mode = mode;
    next_direction = direction;
    next_fall_timer = fall_timer;

    case (mode)
        MODE_SPLAT: begin
            // Remain splatted forever
            next_mode = MODE_SPLAT;
            next_fall_timer = 5'd0;
            // direction unchanged
        end

        MODE_FALL: begin
            if (ground) begin
                // Landed: splatter if fallen more than 20 cycles
                if (fall_timer > 5'd20) begin
                    next_mode = MODE_SPLAT;
                end else begin
                    next_mode = MODE_WALK;
                end
                next_fall_timer = 5'd0;
                // direction unchanged
            end else begin
                next_mode = MODE_FALL;
                // Increment fall_timer but saturate at 21 to reduce toggling beyond threshold
                next_fall_timer = (fall_timer < 5'd21) ? fall_timer + 1'b1 : fall_timer;
                // direction unchanged
            end
        end

        MODE_WALK: begin
            if (!ground) begin
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                // direction unchanged
            end else if (dig) begin
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                // direction unchanged
            end else begin
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;
                // Update direction on bump(s)
                if (bumped) begin
                    // If both bumped, toggle direction
                    if (bump_left & bump_right) begin
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        next_direction = DIR_RIGHT;
                    end else if (bump_right) begin
                        next_direction = DIR_LEFT;
                    end
                end
                // else keep direction
            end
        end

        MODE_DIG: begin
            if (!ground) begin
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                // direction unchanged
            end else begin
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                // direction unchanged
            end
        end

        default: begin
            next_mode = MODE_WALK;
            next_direction = DIR_LEFT;
            next_fall_timer = 5'd0;
        end
    endcase
end

// Sequential registers with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        direction <= DIR_LEFT;
        fall_timer <= 5'd0;
    end else begin
        mode <= next_mode;
        direction <= next_direction;
        fall_timer <= next_fall_timer;
    end
end

// Outputs (Moore machine)
assign walk_left  = (mode == MODE_WALK) && (direction == DIR_LEFT);
assign walk_right = (mode == MODE_WALK) && (direction == DIR_RIGHT);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule