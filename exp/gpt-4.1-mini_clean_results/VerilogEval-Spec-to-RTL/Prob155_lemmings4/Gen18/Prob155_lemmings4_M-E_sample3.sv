module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output wire walk_left,
    output wire walk_right,
    output wire aaah,
    output wire digging
);

    // State encoding
    localparam [1:0]
        WALK  = 2'd0,
        DIG   = 2'd1,
        FALL  = 2'd2,
        SPLAT = 2'd3;

    reg [1:0] state, next_state;
    reg       direction, next_direction;  // 0=left, 1=right
    reg [4:0] fall_count, next_fall_count;

    wire bump_any = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Asynchronous reset and synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0;  // walk left after reset
            fall_count <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            fall_count <= next_fall_count;
        end
    end

    // Next state and outputs logic
    always @(*) begin
        // Defaults hold current values
        next_state     = state;
        next_direction = direction;
        next_fall_count = fall_count;

        case (state)
            SPLAT: begin
                // Once splatted, stay splatted forever until reset
                next_state = SPLAT;
                next_fall_count = 5'd0;
                next_direction = direction;
            end

            FALL: begin
                if (ground) begin
                    // Landing from fall
                    if (fall_count > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK;
                        next_fall_count = 5'd0;
                    end
                    next_direction = direction;  // no change in direction when landing
                end else begin
                    // Continue falling
                    next_state = FALL;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 5'd1;
                    else
                        next_fall_count = fall_count;  // saturate counter
                    next_direction = direction;
                end
            end

            WALK: begin
                if (!ground) begin
                    // Start falling when ground disappears
                    next_state = FALL;
                    next_fall_count = 5'd1;
                    next_direction = direction;  // direction unchanged on fall start
                end else if (dig) begin
                    // Start digging only when on ground and walking
                    next_state = DIG;
                    next_fall_count = 5'd0;
                    next_direction = direction; // direction preserved
                end else begin
                    // Continue walking on ground with possible bump direction switch
                    next_state = WALK;
                    next_fall_count = 5'd0;

                    if (bump_any) begin
                        if (bump_both) begin
                            // Bumped both sides, flip direction
                            next_direction = ~direction;
                        end else if (bump_left) begin
                            // Bumped left, go right
                            next_direction = 1'b1;
                        end else begin
                            // Bumped right, go left
                            next_direction = 1'b0;
                        end
                    end else begin
                        // No bump, keep current direction
                        next_direction = direction;
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    // Digging into no ground -> start falling
                    next_state = FALL;
                    next_fall_count = 5'd1;
                    next_direction = direction; // direction preserved
                end else begin
                    // Continue digging on ground
                    next_state = DIG;
                    next_fall_count = 5'd0;
                    next_direction = direction; // direction preserved
                end
            end

            default: begin
                // Safe default
                next_state = WALK;
                next_direction = 1'b0;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Output assignments - Moore outputs
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule