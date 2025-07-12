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

    // State encoding: 2 bits for 4 states
    localparam MODE_WALK  = 2'd0;
    localparam MODE_DIG   = 2'd1;
    localparam MODE_FALL  = 2'd2;
    localparam MODE_SPLAT = 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer; // fall duration counter (max 31)

    // Combine bump inputs: direction toggles if any bump (left or right)
    wire bump_any = bump_left | bump_right;

    // Enable increment of fall_timer only in FALL mode and timer < 31
    wire fall_timer_en = (mode == MODE_FALL) && (fall_timer < 5'd31);

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode       <= MODE_WALK;
            direction  <= 1'b0;      // start walking left
            fall_timer <= 5'd0;
        end else begin
            mode       <= next_mode;
            direction  <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next-state logic with priority: fall > dig > bump in walk mode
    always @(*) begin
        // Default next state and values
        next_mode      = mode;
        next_direction = direction;
        next_fall_timer = 5'd0; // default reset unless FALL mode

        case (mode)
            MODE_SPLAT: begin
                // Remain splatted indefinitely
                next_mode      = MODE_SPLAT;
                next_direction = direction;
                next_fall_timer = 5'd0;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed: splatter if fallen > 20, else walk same direction
                    if (fall_timer > 5'd20) begin
                        next_mode      = MODE_SPLAT;
                        next_fall_timer = 5'd0;
                    end else begin
                        next_mode      = MODE_WALK;
                        next_fall_timer = 5'd0;
                    end
                    next_direction = direction;
                end else begin
                    // Still falling: increment fall_timer if enabled, else saturate
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    next_fall_timer = fall_timer_en ? fall_timer + 5'd1 : fall_timer;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Start falling when ground disappears
                    next_mode      = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else if (dig) begin
                    // Start digging on ground
                    next_mode      = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else if (bump_any) begin
                    // On bump(s), toggle direction
                    next_mode      = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_direction = ~direction;
                end else begin
                    // Continue walking same direction
                    next_mode      = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Stop digging and start falling when ground lost
                    next_mode      = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    // Continue digging on ground
                    next_mode      = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            default: begin
                // Safety fallback
                next_mode      = MODE_WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs derived combinationally from current state and direction
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule