module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
    localparam WALK  = 2'b00;
    localparam DIG   = 2'b01;
    localparam FALL  = 2'b10;
    localparam SPLAT = 2'b11;

    reg [1:0] state, next_state;
    reg direction, next_direction; // 0=left,1=right
    reg [4:0] fall_timer, next_fall_timer;

    wire bumped = bump_left | bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // walk left
            fall_timer <= 5'd0;
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;

            // Outputs: Moore outputs depend on current state and direction
            walk_left  <= (next_state == WALK) && (next_direction == 1'b0);
            walk_right <= (next_state == WALK) && (next_direction == 1'b1);
            aaah       <= (next_state == FALL);
            digging    <= (next_state == DIG);
        end
    end

    always @* begin
        // Default assignments
        next_state = state;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case (state)
            SPLAT: begin
                // Stays splatted forever
                next_state = SPLAT;
                next_fall_timer = 5'd0;
                // direction unchanged
            end

            FALL: begin
                if (ground) begin
                    // Land on ground
                    if (fall_timer > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_timer = 5'd0;
                    end else begin
                        next_state = WALK;
                        next_fall_timer = 5'd0;
                    end
                    // direction unchanged
                end else begin
                    // Keep falling, increment timer saturating at 31
                    next_state = FALL;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1;
                end
                // direction unchanged while falling
                next_direction = direction;
            end

            WALK: begin
                if (!ground) begin
                    // Start falling
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else if (dig) begin
                    // Start digging
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    // Walk and respond to bumps
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                    if (bump_left & bump_right) begin
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        next_direction = 1'b1; // walk right
                    end else if (bump_right) begin
                        next_direction = 1'b0; // walk left
                    end else begin
                        next_direction = direction;
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    // Fall when ground gone
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    // Keep digging
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            default: begin
                // Reset fallback
                next_state = WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

endmodule