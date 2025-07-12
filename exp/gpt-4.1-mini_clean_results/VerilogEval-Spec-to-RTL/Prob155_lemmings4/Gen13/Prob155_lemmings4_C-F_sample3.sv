module TopModule (
    input  clk,
    input  areset,       // async posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    typedef enum logic [1:0] {
        WALK  = 2'b00,
        DIG   = 2'b01,
        FALL  = 2'b10,
        SPLAT = 2'b11
    } state_t;

    state_t state, next_state;

    // Direction: 0=left, 1=right
    logic direction, next_direction;

    // 5-bit fall timer saturates at 31
    logic [4:0] fall_timer, next_fall_timer;

    // Combinational check for falling too long ( > 20 )
    wire fall_too_long = (fall_timer > 5'd20);

    // Combined bump signals
    wire bump_any  = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Sequential logic with async reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0;      // walk left after reset
            fall_timer <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next-state logic
    always_comb begin
        // Default assignments
        next_state     = state;
        next_direction = direction;
        next_fall_timer = 5'd0;

        case (state)
            SPLAT: begin
                // Stay splatted forever
                next_state     = SPLAT;
                next_direction = direction;
                next_fall_timer = 5'd0;
            end

            FALL: begin
                if (ground) begin
                    // Landed
                    if (fall_too_long) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK;
                    end
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    // Continue falling; increment timer with saturation
                    next_state = FALL;
                    if (fall_timer == 5'd31)
                        next_fall_timer = 5'd31;
                    else
                        next_fall_timer = fall_timer + 1'b1;
                    next_direction = direction;
                end
            end

            DIG: begin
                if (!ground) begin
                    // Lost ground while digging -> fall
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    // Continue digging; ignore bumps/dig during digging
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            WALK: begin
                // Priorities: fall > dig > bump
                if (!ground) begin
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else if (dig) begin
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                    // Change direction only when bumped during walking
                    if (bump_both) begin
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

            default: begin
                next_state = WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs from current state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule