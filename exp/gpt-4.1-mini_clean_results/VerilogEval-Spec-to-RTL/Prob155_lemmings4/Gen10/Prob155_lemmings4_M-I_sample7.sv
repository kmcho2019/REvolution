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

    // Asynchronous posedge reset for state registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0; // walk left
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state logic
    always @(*) begin
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case (mode)
            MODE_SPLAT: begin
                // Remain splatted forever
                next_mode = MODE_SPLAT;
                // fall_timer and direction don't matter here
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed: check splat condition
                    if (fall_timer > 5'd20)
                        next_mode = MODE_SPLAT;
                    else
                        next_mode = MODE_WALK;
                    next_fall_timer = 5'd0; // reset after landing
                end else begin
                    // Continue falling, saturate by limiting increment to max 31
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1;
                end
                // Direction remains unchanged in fall
            end

            MODE_WALK: begin
                if (!ground) begin
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1; // start fall timer
                end else if (dig) begin
                    next_mode = MODE_DIG;
                end else begin
                    // Update direction based on bumps (bumped any side toggles or sets)
                    if (bump_left && bump_right)
                        next_direction = ~direction;
                    else if (bump_left)
                        next_direction = 1'b1; // walk right
                    else if (bump_right)
                        next_direction = 1'b0; // walk left
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                end
                // Direction and digging continues unchanged while ground present
            end
        endcase
    end

    // Moore outputs
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule