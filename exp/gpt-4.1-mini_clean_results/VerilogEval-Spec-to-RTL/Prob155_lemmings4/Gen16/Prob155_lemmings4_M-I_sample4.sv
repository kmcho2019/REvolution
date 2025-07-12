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

    // State encoding
    typedef enum logic [1:0] {
        WALK  = 2'b00,
        DIG   = 2'b01,
        FALL  = 2'b10,
        SPLAT = 2'b11
    } state_t;

    state_t state, next_state;

    // Direction: 0=left, 1=right
    logic direction, next_direction;

    // 5-bit fall timer (counts up to 31)
    logic [4:0] fall_timer, next_fall_timer;

    // Combine bump inputs into 2-bit vector for simpler logic
    wire [1:0] bump = {bump_left, bump_right};
    wire bump_any = |bump;
    wire bump_both = &bump;

    // Splat condition when fall_timer > 20
    wire splat_condition = (fall_timer > 5'd20);

    // Determine if any register update is needed (disable in SPLAT to save power)
    wire update_en = (state != SPLAT);

    // Next state and direction combinational logic
    always_comb begin
        next_state      = state;
        next_direction  = direction;
        next_fall_timer = fall_timer;

        case (state)
            SPLAT: begin
                // No transitions, hold state and values
                next_state      = SPLAT;
                next_fall_timer = 5'd0;
                // direction unchanged
            end

            FALL: begin
                if (ground) begin
                    if (splat_condition) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK;
                    end
                    next_fall_timer = 5'd0;
                    next_direction = direction; // hold direction on landing
                end else begin
                    next_state = FALL;
                    // fall_timer increment handled separately to shorten path
                    next_direction = direction;
                    next_fall_timer = fall_timer;
                end
            end

            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                    // start fall timer in separate logic
                    next_direction = direction;
                    next_fall_timer = fall_timer;
                end else begin
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    next_fall_timer = fall_timer;
                    next_direction = direction;
                end else if (dig) begin
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                    // Simplified direction update with bump vector case
                    casez (bump)
                        2'b11: next_direction = ~direction;  // both bumps: toggle
                        2'b10: next_direction = 1'b1;        // bump left: walk right
                        2'b01: next_direction = 1'b0;        // bump right: walk left
                        default: next_direction = direction; // no bump
                    endcase
                end
            end

            default: begin
                next_state      = WALK;
                next_direction  = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Fall timer increment separated to reduce combinational logic depth
    logic fall_timer_inc;
    always_comb begin
        fall_timer_inc = 1'b0;
        if (state == FALL && !ground) begin
            fall_timer_inc = 1'b1;
        end
    end

    // Sequential registers with clock enable and async reset
    // Registers update only when update_en asserted to save power
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0;
            fall_timer <= 5'd0;
        end else if (update_en) begin
            state      <= next_state;
            direction  <= next_direction;
            // Increment fall_timer saturates at 31
            if (fall_timer_inc) begin
                fall_timer <= (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
            end else begin
                fall_timer <= next_fall_timer;
            end
        end
        // else hold current registers in SPLAT state (clock gated)
    end

    // Moore outputs
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule