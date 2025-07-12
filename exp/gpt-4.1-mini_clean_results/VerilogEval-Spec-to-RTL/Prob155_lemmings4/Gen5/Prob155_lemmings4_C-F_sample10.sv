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

    // Mode encoding
    localparam MODE_WALK  = 2'd0;
    localparam MODE_DIG   = 2'd1;
    localparam MODE_FALL  = 2'd2;
    localparam MODE_SPLAT = 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;

    // Asynchronous reset and state registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0;      // start walking left
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and outputs logic
    always @(*) begin
        // Default assignments
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case (mode)
            MODE_SPLAT: begin
                // Remain splatted forever, no changes
                next_mode = MODE_SPLAT;
                next_fall_timer = 5'd0;
                // direction irrelevant, hold it
                next_direction = direction;
            end

            MODE_FALL: begin
                if (ground == 1'b1) begin
                    // Landed on ground
                    if (fall_timer > 5'd20) begin
                        // Splatter due to long fall
                        next_mode = MODE_SPLAT;
                        next_fall_timer = 5'd0;
                        next_direction = direction; 
                    end else begin
                        // Resume walking same direction
                        next_mode = MODE_WALK;
                        next_fall_timer = 5'd0;
                        next_direction = direction;
                    end
                end else begin
                    // Continue falling, increment timer saturating at 31
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    if (fall_timer < 5'd31)
                        next_fall_timer = fall_timer + 5'd1;
                    else
                        next_fall_timer = fall_timer;
                end
            end

            MODE_WALK: begin
                // Priority: fall > dig > bump
                if (ground == 1'b0) begin
                    // Start falling
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction; // keep direction during fall
                end else if (dig == 1'b1) begin
                    // Start digging
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    // Handle bumps explicitly per spec:
                    // If bump_left && bump_right, toggle direction
                    // else if bump_left, walk right (1)
                    // else if bump_right, walk left (0)
                    // else keep current direction
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    if (bump_left && bump_right) begin
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        next_direction = 1'b1;  // walk right
                    end else if (bump_right) begin
                        next_direction = 1'b0;  // walk left
                    end else begin
                        next_direction = direction;
                    end
                end
            end

            MODE_DIG: begin
                if (ground == 1'b0) begin
                    // Lost ground while digging, start falling
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    // Continue digging on ground, bumps and dig ignored
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            default: begin
                // Defensive: reset to walking left
                next_mode = MODE_WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs based on mode and direction
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule