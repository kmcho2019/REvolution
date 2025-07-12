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

    // State encoding
    localparam MODE_WALK = 2'd0;
    localparam MODE_DIG  = 2'd1;
    localparam MODE_FALL = 2'd2;
    localparam MODE_SPLAT= 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;

    wire bump = bump_left | bump_right;
    wire bump_toggle = (bump_left & bump_right) | (bump_left & ~bump_right) | (~bump_left & bump_right);
    // bump_toggle is true if bumped on either side or both, meaning direction changes accordingly.

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0;  // walk left at reset
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    always @(*) begin
        // Defaults
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = 5'd0;

        case (mode)
            MODE_SPLAT: begin
                // Remain splatted forever
                next_mode = MODE_SPLAT;
                next_direction = direction;
                next_fall_timer = 5'd0;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed
                    if (fall_timer > 5'd20)
                        next_mode = MODE_SPLAT;
                    else
                        next_mode = MODE_WALK;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end else begin
                    // Keep falling, saturate at 31
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 5'd1 : 5'd31;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Start falling
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging on ground
                    next_mode = MODE_DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end else if (bump) begin
                    // Switch direction based on bump:
                    // if both sides bumped, toggle direction; else bump left->walk right; bump right->walk left
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    if (bump_left & bump_right)
                        next_direction = ~direction;
                    else if (bump_left)
                        next_direction = 1'b1; // walk right
                    else
                        next_direction = 1'b0; // walk left
                end else begin
                    // Continue walking same direction
                    next_mode = MODE_WALK;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Ground gone, start falling
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging
                    next_mode = MODE_DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                // Safety reset
                next_mode = MODE_WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule