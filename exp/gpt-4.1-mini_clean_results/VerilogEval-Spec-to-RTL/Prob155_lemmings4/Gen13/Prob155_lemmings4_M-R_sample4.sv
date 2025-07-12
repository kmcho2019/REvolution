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

    // One-hot state encoding
    localparam WALK  = 3'b001;
    localparam DIG   = 3'b010;
    localparam FALL  = 3'b100;
    localparam SPLAT = 3'b000; // SPLAT represented implicitly when no other bit set (or can add a 4th bit if desired)

    // For simplicity, define SPLAT explicitly as 4-bit one-hot
    localparam [3:0]
      ST_WALK  = 4'b0001,
      ST_DIG   = 4'b0010,
      ST_FALL  = 4'b0100,
      ST_SPLAT = 4'b1000;

    reg [3:0] state, next_state;

    // Direction: 0=left, 1=right
    reg direction, next_direction;

    // 5-bit fall timer (counts up to 31)
    reg [4:0] fall_timer, next_fall_timer;

    wire bump_any = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    wire splat_condition = (fall_timer > 5'd20);

    // State register and direction and timer
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= ST_WALK;
            direction  <= 1'b0;       // walk left after reset
            fall_timer <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and timer logic combinational
    always_comb begin
        // Defaults
        next_state      = state;
        next_fall_timer = fall_timer;

        // Keep fall_timer saturated at 31
        case (1'b1)
            state[3]: begin // SPLAT
                // Stay splatted forever, no fall timer needed
                next_state = ST_SPLAT;
                next_fall_timer = 5'd0;
            end

            state[2]: begin // FALL
                if (ground) begin
                    // Landed
                    if (splat_condition) begin
                        next_state = ST_SPLAT;
                        next_fall_timer = 5'd0;
                    end else begin
                        next_state = ST_WALK;
                        next_fall_timer = 5'd0;
                    end
                end else begin
                    // Continue falling, increment timer saturating at 31
                    next_state = ST_FALL;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 5'd1;
                end
            end

            state[1]: begin // DIG
                if (!ground) begin
                    // Lost ground while digging => fall
                    next_state = ST_FALL;
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging
                    next_state = ST_DIG;
                    next_fall_timer = 5'd0;
                end
            end

            state[0]: begin // WALK
                if (!ground) begin
                    // Start falling
                    next_state = ST_FALL;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging only if on ground
                    next_state = ST_DIG;
                    next_fall_timer = 5'd0;
                end else begin
                    // Continue walking
                    next_state = ST_WALK;
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                next_state = ST_WALK;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Direction logic separated: synchronous block to update direction only in WALK state and on bump conditions with priority rules
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // walk left after reset
        end else begin
            if (state == ST_WALK && next_state == ST_WALK) begin
                // Only update direction on bumps if staying in walk state
                if (bump_both) begin
                    direction <= ~direction;
                end else if (bump_left) begin
                    direction <= 1'b1; // walk right
                end else if (bump_right) begin
                    direction <= 1'b0; // walk left
                end else begin
                    direction <= direction; // no change
                end
            end else begin
                // Keep direction unchanged in other states
                direction <= direction;
            end
        end
    end

    // Outputs as pure combinational from one-hot states and direction
    assign walk_left  = (state == ST_WALK) && (direction == 1'b0);
    assign walk_right = (state == ST_WALK) && (direction == 1'b1);
    assign aaah       = (state == ST_FALL);
    assign digging    = (state == ST_DIG);

endmodule