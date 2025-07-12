module TopModule (
    input  clk,
    input  areset,       // synchronous active-high reset (design tradeoff from spec)
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot states (5 bits)
    localparam WALK_LEFT  = 5'b00001;
    localparam WALK_RIGHT = 5'b00010;
    localparam FALL       = 5'b00100;
    localparam DIG        = 5'b01000;
    localparam SPLAT      = 5'b10000;

    reg [4:0] state, next_state;

    // Saturating 6-bit fall counter (count to 31 max)
    reg [5:0] fall_count, next_fall_count;

    // Previous walking state to remember direction after fall
    reg walk_left_dir, next_walk_left_dir;

    wire bump_both = bump_left & bump_right;
    wire bump_only_left = bump_left & ~bump_right;
    wire bump_only_right = bump_right & ~bump_left;
    wire bump_any = bump_left | bump_right;

    // Sequential logic
    always @(posedge clk) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 6'd0;
            walk_left_dir <= 1'b1;  // direction = left
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
            walk_left_dir <= next_walk_left_dir;
        end
    end

    // Combinational next-state logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_fall_count = fall_count;
        next_walk_left_dir = walk_left_dir;

        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    // start falling
                    next_state = FALL;
                    next_fall_count = 6'd1;
                end else if (dig) begin
                    // start digging if on ground
                    next_state = DIG;
                end else if (bump_both) begin
                    // bump both sides: switch direction
                    next_state = WALK_RIGHT;
                    next_walk_left_dir = 1'b0;
                end else if (bump_only_left) begin
                    // bump left: walk right
                    next_state = WALK_RIGHT;
                    next_walk_left_dir = 1'b0;
                end else if (bump_only_right) begin
                    // bump right: walk left (already left, stay)
                    next_state = WALK_LEFT;
                    next_walk_left_dir = 1'b1;
                end else begin
                    // no bump, keep walking left
                    next_state = WALK_LEFT;
                    next_walk_left_dir = 1'b1;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                    next_fall_count = 6'd1;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_both) begin
                    next_state = WALK_LEFT;
                    next_walk_left_dir = 1'b1;
                end else if (bump_only_left) begin
                    next_state = WALK_RIGHT;
                    next_walk_left_dir = 1'b0;
                end else if (bump_only_right) begin
                    next_state = WALK_LEFT;
                    next_walk_left_dir = 1'b1;
                end else begin
                    next_state = WALK_RIGHT;
                    next_walk_left_dir = 1'b0;
                end
            end

            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                    next_fall_count = 6'd1;
                    // Keep walking direction as before digging
                end else begin
                    next_state = DIG;
                    next_fall_count = 6'd0;
                    // walking direction remains unchanged
                end
            end

            FALL: begin
                if (!ground) begin
                    // continue falling
                    next_state = FALL;
                    if (fall_count < 6'd31)
                        next_fall_count = fall_count + 6'd1;
                    else
                        next_fall_count = fall_count;
                    // keep walking direction unchanged
                end else begin
                    // landed on ground
                    if (fall_count > 6'd20) begin
                        next_state = SPLAT;
                        next_fall_count = 6'd0;
                    end else begin
                        // resume walking in original direction
                        next_state = walk_left_dir ? WALK_LEFT : WALK_RIGHT;
                        next_fall_count = 6'd0;
                    end
                end
                // walking direction not changed here
            end

            SPLAT: begin
                // remain splattered forever
                next_state = SPLAT;
                next_fall_count = 6'd0;
            end

            default: begin
                // Safety default: walk left
                next_state = WALK_LEFT;
                next_fall_count = 6'd0;
                next_walk_left_dir = 1'b1;
            end
        endcase
    end

    // Outputs: Moore outputs only depend on current state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule