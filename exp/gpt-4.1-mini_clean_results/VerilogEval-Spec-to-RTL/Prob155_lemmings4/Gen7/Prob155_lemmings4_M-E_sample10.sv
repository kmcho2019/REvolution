module TopModule (
    input  clk,
    input  areset,       // asynchronous positive edge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding (3 bits):
    localparam [2:0]
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        FALL_LEFT  = 3'd2,
        FALL_RIGHT = 3'd3,
        DIG_LEFT   = 3'd4,
        DIG_RIGHT  = 3'd5,
        SPLAT      = 3'd6;

    reg [2:0] state, next_state;

    // Saturating 5-bit fall counter (0 to 31)
    reg [4:0] fall_count, next_fall_count;

    // Bump detection
    wire bump_both = bump_left & bump_right;
    wire bump_only_left = bump_left & ~bump_right;
    wire bump_only_right = bump_right & ~bump_left;
    wire bumped = bump_left | bump_right;

    // Helpers for walking and digging states to extract direction
    // Direction: 0 = left, 1 = right
    wire walking = (state == WALK_LEFT) || (state == WALK_RIGHT);
    wire falling = (state == FALL_LEFT) || (state == FALL_RIGHT);
    wire digging_state = (state == DIG_LEFT) || (state == DIG_RIGHT);
    wire splatted = (state == SPLAT);
    wire direction = (state == WALK_RIGHT) || (state == FALL_RIGHT) || (state == DIG_RIGHT);

    // Next state logic
    always @(*) begin
        next_state = state;
        next_fall_count = fall_count;

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Fall left starting
                    next_state = FALL_LEFT;
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    // Start digging left
                    next_state = DIG_LEFT;
                    next_fall_count = 5'd0;
                end else begin
                    // Handle bumps
                    if (bump_both) begin
                        next_state = WALK_RIGHT; // toggle direction
                        next_fall_count = 5'd0;
                    end else if (bump_only_left) begin
                        next_state = WALK_RIGHT; // bumped left, walk right
                        next_fall_count = 5'd0;
                    end else if (bump_only_right) begin
                        next_state = WALK_LEFT;  // bumped right, walk left (stay)
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_LEFT;  // no bump, stay
                        next_fall_count = 5'd0;
                    end
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    // Fall right starting
                    next_state = FALL_RIGHT;
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    // Start digging right
                    next_state = DIG_RIGHT;
                    next_fall_count = 5'd0;
                end else begin
                    // Handle bumps
                    if (bump_both) begin
                        next_state = WALK_LEFT;  // toggle direction
                        next_fall_count = 5'd0;
                    end else if (bump_only_left) begin
                        next_state = WALK_RIGHT; // bumped left, walk right (stay)
                        next_fall_count = 5'd0;
                    end else if (bump_only_right) begin
                        next_state = WALK_LEFT;  // bumped right, walk left
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_RIGHT; // no bump, stay
                        next_fall_count = 5'd0;
                    end
                end
            end

            FALL_LEFT: begin
                if (!ground) begin
                    // Continue falling left, saturate counter at 31
                    next_state = FALL_LEFT;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 1'b1;
                    else
                        next_fall_count = fall_count;
                end else begin
                    // Landed from fall left
                    if (fall_count > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_LEFT;
                        next_fall_count = 5'd0;
                    end
                end
            end

            FALL_RIGHT: begin
                if (!ground) begin
                    // Continue falling right, saturate counter at 31
                    next_state = FALL_RIGHT;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 1'b1;
                    else
                        next_fall_count = fall_count;
                end else begin
                    // Landed from fall right
                    if (fall_count > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_RIGHT;
                        next_fall_count = 5'd0;
                    end
                end
            end

            DIG_LEFT: begin
                if (!ground) begin
                    // Ground lost while digging, start falling left
                    next_state = FALL_LEFT;
                    next_fall_count = 5'd1;
                end else begin
                    // Continue digging left
                    next_state = DIG_LEFT;
                    next_fall_count = 5'd0;
                end
            end

            DIG_RIGHT: begin
                if (!ground) begin
                    // Ground lost while digging, start falling right
                    next_state = FALL_RIGHT;
                    next_fall_count = 5'd1;
                end else begin
                    // Continue digging right
                    next_state = DIG_RIGHT;
                    next_fall_count = 5'd0;
                end
            end

            SPLAT: begin
                // Remain splattered forever
                next_state = SPLAT;
                next_fall_count = 5'd0;
            end

            default: begin
                // Reset fallback: walk left
                next_state = WALK_LEFT;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // State and counter registers with async positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // Outputs: Moore outputs depend only on state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule