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

    // State encoding as parameters for readability
    localparam [1:0] MODE_WALK  = 2'd0;
    localparam [1:0] MODE_DIG   = 2'd1;
    localparam [1:0] MODE_FALL  = 2'd2;
    localparam [1:0] MODE_SPLAT = 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction;  // 0=left, 1=right
    reg [4:0] fall_timer;
    reg [4:0] next_fall_timer;

    // Signals to indicate bump conditions
    wire bump = bump_left | bump_right;
    wire both_bump = bump_left & bump_right;
    wire bump_left_only = bump_left & ~bump_right;
    wire bump_right_only = bump_right & ~bump_left;

    // Compute next_mode, next_direction, next_fall_timer combinationally
    always_comb begin
        // Defaults: hold current values
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
                    // Landed on ground; check fall duration for splatter
                    if (fall_timer > 5'd20)
                        next_mode = MODE_SPLAT;
                    else
                        next_mode = MODE_WALK;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end else begin
                    // Still falling: increment fall_timer with saturation at 31
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    next_fall_timer = (fall_timer < 5'd31) ? (fall_timer + 5'd1) : 5'd31;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Ground disappeared: start falling with timer at 1
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging if on ground
                    next_mode = MODE_DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end else if (bump) begin
                    // Switch direction on bump(s)
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    if (both_bump)
                        next_direction = ~direction;
                    else if (bump_left_only)
                        next_direction = 1'b1; // walk right
                    else if (bump_right_only)
                        next_direction = 1'b0; // walk left
                    else
                        next_direction = direction;
                end else begin
                    // Continue walking same direction
                    next_mode = MODE_WALK;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Lost ground during dig: fall with timer=1
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
                // Defensive defaults: start walking left
                next_mode = MODE_WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // State and direction registers update with async reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0;
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Moore outputs derived directly from registered state and direction
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule