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

    // Strongly typed enum for states
    typedef enum logic [1:0] {
        WALK  = 2'd0,
        DIG   = 2'd1,
        FALL  = 2'd2,
        SPLAT = 2'd3
    } state_t;

    state_t state, next_state;

    // Direction: 0 = left, 1 = right
    logic direction, next_direction;

    // 5-bit fall timer, saturates at 21
    logic [4:0] fall_timer, next_fall_timer;

    wire bump_any  = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Sequential logic with async posedge reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0;   // walk left
            fall_timer <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next-state logic
    always_comb begin
        // Defaults: hold current values
        next_state      = state;
        next_direction  = direction;
        next_fall_timer = 5'd0;

        case(state)
            SPLAT: begin
                // Remain splatted indefinitely
                next_state      = SPLAT;
                next_direction  = direction;
                next_fall_timer = 5'd0;
            end

            FALL: begin
                if (ground) begin
                    // Landed: splat if fell too long (>20 cycles)
                    if (fall_timer > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = WALK;
                    next_fall_timer = 5'd0;
                    next_direction  = direction;
                end else begin
                    // Continue falling; increment timer saturating at 21
                    next_state      = FALL;
                    next_fall_timer = (fall_timer < 5'd21) ? fall_timer + 1'b1 : 5'd21;
                    next_direction  = direction;
                end
            end

            DIG: begin
                if (!ground) begin
                    // Lost ground while digging: start falling
                    next_state      = FALL;
                    next_fall_timer = 5'd1;
                    next_direction  = direction;
                end else begin
                    // Continue digging
                    next_state      = DIG;
                    next_direction  = direction;
                    next_fall_timer = 5'd0;
                end
            end

            WALK: begin
                if (!ground) begin
                    // Start falling
                    next_state      = FALL;
                    next_fall_timer = 5'd1;
                    next_direction  = direction;
                end else if (dig) begin
                    // Start digging if requested and on ground
                    next_state      = DIG;
                    next_direction  = direction;
                    next_fall_timer = 5'd0;
                end else begin
                    // Stay walking; update direction on bumps
                    next_state      = WALK;
                    next_fall_timer = 5'd0;
                    if (bump_both)
                        next_direction = ~direction; // switch direction
                    else if (bump_left)
                        next_direction = 1'b1; // walk right
                    else if (bump_right)
                        next_direction = 1'b0; // walk left
                    else
                        next_direction = direction;
                end
            end

            default: begin
                // Defensive fallback to walk left
                next_state      = WALK;
                next_direction  = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs depend only on current state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule