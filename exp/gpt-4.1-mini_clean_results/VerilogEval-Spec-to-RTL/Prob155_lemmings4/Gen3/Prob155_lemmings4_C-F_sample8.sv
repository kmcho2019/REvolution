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
localparam MODE_WALK = 2'd0;
localparam MODE_DIG  = 2'd1;
localparam MODE_FALL = 2'd2;
localparam MODE_SPLAT= 2'd3;

reg [1:0] mode, next_mode;
reg direction, next_direction;   // 0=left, 1=right
reg [4:0] fall_timer, next_fall_timer; // counts falling cycles

// Sequential logic with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        direction <= 1'b0;   // start walking left
        fall_timer <= 5'd0;
    end else begin
        mode <= next_mode;
        direction <= next_direction;
        fall_timer <= next_fall_timer;
    end
end

// Next state logic combinational
always_comb begin
    // Defaults: hold current state and direction, zero fall_timer outside fall
    next_mode = mode;
    next_direction = direction;
    next_fall_timer = 5'd0;

    case (mode)
        MODE_SPLAT: begin
            // Remain splattered forever until reset
            next_mode = MODE_SPLAT;
            next_fall_timer = 5'd0;
            next_direction = direction; // direction irrelevant
        end

        MODE_FALL: begin
            if (ground) begin
                // Landed: if fallen too long splatter, else walk same direction
                if (fall_timer > 5'd20) begin
                    next_mode = MODE_SPLAT;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end else begin
                // Still falling: increment timer saturating at max 31
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
                // Start falling; timer=1
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else if (dig) begin
                // Start digging if on ground and walking
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else if (bump_left || bump_right) begin
                // Bump direction logic with priority:
                // bump_left=1 & bump_right=0 => walk right (1)
                // bump_right=1 & bump_left=0 => walk left (0)
                // both bump_left & bump_right=1 => toggle direction
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;
                if (bump_left && bump_right) begin
                    next_direction = ~direction;
                end else if (bump_left) begin
                    next_direction = 1'b1; // walk right
                end else if (bump_right) begin
                    next_direction = 1'b0; // walk left
                end else begin
                    next_direction = direction; // no change (should not occur)
                end
            end else begin
                // No bump, continue walking same direction
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end

        MODE_DIG: begin
            if (!ground) begin
                // Lost ground while digging: start falling
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
            // Safety fallback to walking left
            next_mode = MODE_WALK;
            next_direction = 1'b0;
            next_fall_timer = 5'd0;
        end
    endcase
end

// Moore outputs: depend only on mode and direction
assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule