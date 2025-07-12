module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Mode/state encoding: 2 bits
    localparam MODE_WALK = 2'd0;
    localparam MODE_DIG  = 2'd1;
    localparam MODE_FALL = 2'd2;
    localparam MODE_SPLAT= 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer; // fall duration counter

    // Asynchronous reset, clocked sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0;  // start walking left
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next-state logic with priority: fall > dig > bump in walk mode
    always @(*) begin
        // Default to hold current state
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case (mode)
            MODE_SPLAT: begin
                // Splattered forever; no output change
                next_mode = MODE_SPLAT;
                next_fall_timer = 5'd0;
                // direction irrelevant, keep stable
                next_direction = direction;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed: splat if fallen > 20 cycles, else walk with same direction
                    if (fall_timer > 5'd20) begin
                        next_mode = MODE_SPLAT;
                        next_fall_timer = 5'd0;
                    end else begin
                        next_mode = MODE_WALK;
                        next_fall_timer = 5'd0;
                    end
                    next_direction = direction;
                end else begin
                    // Continue falling, saturate fall timer at 31
                    next_mode = MODE_FALL;
                    if (fall_timer < 5'd31)
                        next_fall_timer = fall_timer + 5'd1;
                    else
                        next_fall_timer = fall_timer;
                    next_direction = direction;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // No ground, start falling with timer=1
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else if (dig) begin
                    // On ground and dig requested, start digging
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else if (bump_left || bump_right) begin
                    // Bump direction logic:
                    // - both bumps: toggle direction
                    // - bump_left only: walk right (1)
                    // - bump_right only: walk left (0)
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    if (bump_left && bump_right) begin
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        next_direction = 1'b1; // walk right
                    end else begin
                        // bump_right only (since bump_left || bump_right is true)
                        next_direction = 1'b0; // walk left
                    end
                end else begin
                    // Continue walking, no bump
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Ground lost during digging, start falling
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
                // Safety: reset to walk left
                next_mode = MODE_WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs derived only from current state and direction
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule